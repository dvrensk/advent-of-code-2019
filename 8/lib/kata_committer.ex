defmodule KataCommitter do
  use GenServer

  @moduledoc """
  Commits and pushes the current project iff (1) all tests pass and
  (2) the list of passing tests is not the same as in the previous
  commit.  Useful when running katas and dojos.

  To use, put this file in your `lib` folder and change your `test_helper.exs`
  to contain `ExUnit.start(formatters: [KataCommitter, ExUnit.CLIFormatter])`
  """

  def init(_opts) do
    state = %{
      passed: [],
      failed: 0
    }

    {:ok, state}
  end

  # TODO: handle excluded tests.  Their presence indicate that this is not a
  # committable run.

  def handle_cast({:test_finished, test = %ExUnit.Test{state: nil}}, state) do
    {:noreply, %{state | passed: [data_for(test) | state[:passed]]}}
  end

  def handle_cast({:test_finished, _test = %ExUnit.Test{state: {:failed, _}}}, state) do
    {:noreply, %{state | failed: state[:failed] + 1}}
  end

  def handle_cast({:test_finished, _test}, state) do
    {:noreply, state}
  end

  def handle_cast({:suite_finished, _run_us, _load_us}, state = %{failed: 0}) do
    case difference_from_last_commit(state) do
      {[], []} ->
        nil

      {added, removed} ->
        persist_state(state)
        git_add()
        git_commit(added, removed)
        git_push_in_background()
    end

    {:noreply, state}
  end

  def handle_cast({:suite_finished, _run_us, _load_us}, state), do: {:noreply, state}

  def handle_cast(_, state), do: {:noreply, state}

  def data_for(test = %{state: nil}) do
    name =
      Atom.to_string(test.name)
      |> String.trim_leading("test ")

    module =
      Atom.to_string(test.case)
      |> String.trim_leading("Elixir.")
      |> String.trim_trailing("Test")

    %{
      message: "#{module} #{name}",
      line: test.tags[:line]
    }
  end

  @passing_tests_file ".passing_tests"

  def difference_from_last_commit(%{passed: passed}) do
    passed_now = MapSet.new(passed, fn %{message: msg} -> msg end)

    passed_in_last =
      case File.read(@passing_tests_file) do
        {:ok, content} ->
          String.split(content, "\n", trim: true)
          |> MapSet.new()

        {:error, :enoent} ->
          MapSet.new()
      end

    line_numbers = Map.new(passed, fn %{message: msg, line: line} -> {msg, line} end)

    {
      sorted_diff(passed_now, passed_in_last, line_numbers),
      sorted_diff(passed_in_last, passed_now, line_numbers)
    }
  end

  def sorted_diff(a, b, line_numbers) do
    MapSet.difference(a, b)
    |> MapSet.to_list()
    |> Enum.sort_by(fn str -> line_numbers[str] end)
  end

  def persist_state(%{passed: passed}) do
    messages = MapSet.new(passed, fn %{message: msg} -> msg end)
    File.write(@passing_tests_file, Enum.join(messages, "\n"))
  end

  def git_add() do
    cmd('git add . ' ++ String.to_charlist(@passing_tests_file))
  end

  def git_commit(added, removed) do
    msg = commit_msg(added, removed)
    IO.puts(">>> Yay, new tests pass! Committing and pushing:\n#{msg}")
    File.write!(commit_msg_path(), msg)
    cmd('git commit -q -F ' ++ String.to_charlist(commit_msg_path()))
    File.rm(commit_msg_path())
  end

  def git_push_in_background() do
    Port.open({:spawn, "git push -q origin"}, [:binary, :use_stdio])
  end

  def cmd(string) do
    case :os.cmd(string) do
      '' -> nil
      x -> IO.inspect(x, label: string)
    end
  end

  @commit_msg_file "kata_committer_msg.txt"

  def commit_msg_path(), do: Path.join(System.tmp_dir!(), @commit_msg_file)

  def commit_msg(added, removed) do
    [
      Enum.map(added, fn s -> "[ADD] #{s}" end),
      "",
      Enum.map(removed, fn s -> "[DEL] #{s}" end)
    ]
    |> List.flatten()
    |> Enum.join("\n")
    |> String.trim()
  end
end
