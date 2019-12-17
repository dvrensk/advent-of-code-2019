defmodule NbodyTest do
  use ExUnit.Case

  @start_1 """
  <x=-1, y=0, z=2>
  <x=2, y=-10, z=-7>
  <x=4, y=-8, z=8>
  <x=3, y=5, z=-1>
  """

  @after_0 """
  pos=<x=-1, y=  0, z= 2>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 2, y=-10, z=-7>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 4, y= -8, z= 8>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 3, y=  5, z=-1>, vel=<x= 0, y= 0, z= 0>
  """

  @after_1 """
  pos=<x= 2, y=-1, z= 1>, vel=<x= 3, y=-1, z=-1>
  pos=<x= 3, y=-7, z=-4>, vel=<x= 1, y= 3, z= 3>
  pos=<x= 1, y=-7, z= 5>, vel=<x=-3, y= 1, z=-3>
  pos=<x= 2, y= 2, z= 0>, vel=<x=-1, y=-3, z= 1>
  """

  @after_2 """
  pos=<x= 5, y=-3, z=-1>, vel=<x= 3, y=-2, z=-2>
  pos=<x= 1, y=-2, z= 2>, vel=<x=-2, y= 5, z= 6>
  pos=<x= 1, y=-4, z=-1>, vel=<x= 0, y= 3, z=-6>
  pos=<x= 1, y=-4, z= 2>, vel=<x=-1, y=-6, z= 2>
  """

  @after_3 """
  pos=<x= 5, y=-6, z=-1>, vel=<x= 0, y=-3, z= 0>
  pos=<x= 0, y= 0, z= 6>, vel=<x=-1, y= 2, z= 4>
  pos=<x= 2, y= 1, z=-5>, vel=<x= 1, y= 5, z=-4>
  pos=<x= 1, y=-8, z= 2>, vel=<x= 0, y=-4, z= 0>
  """

  @after_4 """
  pos=<x= 2, y=-8, z= 0>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 2, y= 1, z= 7>, vel=<x= 2, y= 1, z= 1>
  pos=<x= 2, y= 3, z=-6>, vel=<x= 0, y= 2, z=-1>
  pos=<x= 2, y=-9, z= 1>, vel=<x= 1, y=-1, z=-1>
  """

  @after_5 """
  pos=<x=-1, y=-9, z= 2>, vel=<x=-3, y=-1, z= 2>
  pos=<x= 4, y= 1, z= 5>, vel=<x= 2, y= 0, z=-2>
  pos=<x= 2, y= 2, z=-4>, vel=<x= 0, y=-1, z= 2>
  pos=<x= 3, y=-7, z=-1>, vel=<x= 1, y= 2, z=-2>
  """

  @after_6 """
  pos=<x=-1, y=-7, z= 3>, vel=<x= 0, y= 2, z= 1>
  pos=<x= 3, y= 0, z= 0>, vel=<x=-1, y=-1, z=-5>
  pos=<x= 3, y=-2, z= 1>, vel=<x= 1, y=-4, z= 5>
  pos=<x= 3, y=-4, z=-2>, vel=<x= 0, y= 3, z=-1>
  """

  @after_7 """
  pos=<x= 2, y=-2, z= 1>, vel=<x= 3, y= 5, z=-2>
  pos=<x= 1, y=-4, z=-4>, vel=<x=-2, y=-4, z=-4>
  pos=<x= 3, y=-7, z= 5>, vel=<x= 0, y=-5, z= 4>
  pos=<x= 2, y= 0, z= 0>, vel=<x=-1, y= 4, z= 2>
  """

  @after_8 """
  pos=<x= 5, y= 2, z=-2>, vel=<x= 3, y= 4, z=-3>
  pos=<x= 2, y=-7, z=-5>, vel=<x= 1, y=-3, z=-1>
  pos=<x= 0, y=-9, z= 6>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 1, y= 1, z= 3>, vel=<x=-1, y= 1, z= 3>
  """

  @after_9 """
  pos=<x= 5, y= 3, z=-4>, vel=<x= 0, y= 1, z=-2>
  pos=<x= 2, y=-9, z=-3>, vel=<x= 0, y=-2, z= 2>
  pos=<x= 0, y=-8, z= 4>, vel=<x= 0, y= 1, z=-2>
  pos=<x= 1, y= 1, z= 5>, vel=<x= 0, y= 0, z= 2>
  """

  @after_10 """
  pos=<x= 2, y= 1, z=-3>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 1, y=-8, z= 0>, vel=<x=-1, y= 1, z= 3>
  pos=<x= 3, y=-6, z= 1>, vel=<x= 3, y= 2, z=-3>
  pos=<x= 2, y= 0, z= 4>, vel=<x= 1, y=-1, z=-1>
  """

  test "it renders the state in a readable form" do
    assert Nbody.render(Nbody.new(@start_1)) == compact(@after_0)
  end

  test "it renders the state after several step" do
    next = Nbody.step(Nbody.new(@start_1))
    assert Nbody.render(next) == compact(@after_1)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_2)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_3)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_4)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_5)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_6)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_7)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_8)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_9)
    next = Nbody.step(next)
    assert Nbody.render(next) == compact(@after_10)
  end

  @energy_10 """
  pot: 2 + 1 + 3 =  6;   kin: 3 + 2 + 1 = 6;   total:  6 * 6 = 36
  pot: 1 + 8 + 0 =  9;   kin: 1 + 1 + 3 = 5;   total:  9 * 5 = 45
  pot: 3 + 6 + 1 = 10;   kin: 3 + 2 + 3 = 8;   total: 10 * 8 = 80
  pot: 2 + 0 + 4 =  6;   kin: 1 + 1 + 1 = 3;   total:  6 * 3 = 18
  Sum of total energy: 36 + 45 + 80 + 18 = 179
  """

  test "it calculates the energy in the system" do
    after_10 = Nbody.step_several(10, Nbody.new(@start_1))
    assert Nbody.render(after_10) == compact(@after_10)

    assert Nbody.render_energy(after_10) == compact(@energy_10)
  end

  @start_2 """
  <x=-8, y=-10, z=0>
  <x=5, y=5, z=10>
  <x=2, y=-7, z=3>
  <x=9, y=-8, z=-3>
  """

  @energy_100 """
  pot:  8 + 12 +  9 = 29;   kin: 7 +  3 + 0 = 10;   total: 29 * 10 = 290
  pot: 13 + 16 +  3 = 32;   kin: 3 + 11 + 5 = 19;   total: 32 * 19 = 608
  pot: 29 + 11 +  1 = 41;   kin: 3 +  7 + 4 = 14;   total: 41 * 14 = 574
  pot: 16 + 13 + 23 = 52;   kin: 7 +  1 + 1 =  9;   total: 52 *  9 = 468
  Sum of total energy: 290 + 608 + 574 + 468 = 1940
  """

  test "it calculates the energy in the system, 2nd example" do
    after_100 = Nbody.step_several(100, Nbody.new(@start_2))
    assert Nbody.render_energy(after_100) == compact(@energy_100)
  end

  @input """
  <x=-3, y=15, z=-11>
  <x=3, y=13, z=-19>
  <x=-13, y=18, z=-2>
  <x=6, y=0, z=-1>
  """

  @energy_1000 """
  pot: 19+66+39=124; kin: 9+2+2=13; total: 124*13=1612
  pot: 49+46+2=97; kin: 5+17+9=31; total: 97*31=3007
  pot: 121+30+28=179; kin: 16+0+3=19; total: 179*19=3401
  pot: 60+4+98=162; kin: 2+15+8=25; total: 162*25=4050
  Sumoftotalenergy: 1612+3007+3401+4050=12070
  """

  test "it calculates the energy in the system, task 1" do
    after_1000 = Nbody.step_several(1000, Nbody.new(@input))
    assert Nbody.render_energy(after_1000) == compact(@energy_1000)
  end

  def compact(string) do
    s1 = Regex.replace(~r/ +/, string, "")
    Regex.replace(~r/(?<=[,:;])/, s1, " ")
  end
end
