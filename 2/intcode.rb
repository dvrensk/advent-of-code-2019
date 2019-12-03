class Intcode
  def initialize(memory)
    @memory = memory
    @ip = 0
  end
  attr_reader :memory, :ip

  WELL_KNOWN_PROGRAM = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,19,5,23,2,23,13,27,1,10,27,31,2,31,6,35,1,5,35,39,1,39,10,43,2,9,43,47,1,47,5,51,2,51,9,55,1,13,55,59,1,13,59,63,1,6,63,67,2,13,67,71,1,10,71,75,2,13,75,79,1,5,79,83,2,83,9,87,2,87,13,91,1,91,5,95,2,9,95,99,1,99,5,103,1,2,103,107,1,10,107,0,99,2,14,0,0"

  def self.run(memory)
    vm = new(memory)
    vm.run
    vm.memory
  end

  def self.noun_verb(noun, verb)
    memory = WELL_KNOWN_PROGRAM.split(",").map(&:to_i)
    memory[1] = noun
    memory[2] = verb
    run(memory)[0]
  end

  ADD = 1
  MUL = 2
  HLT = 99

  def run
    loop do
      case memory[ip]
      when ADD
        memory[res] = memory[op1] + memory[op2]
      when MUL
        memory[res] = memory[op1] * memory[op2]
      when HLT
        return
      end
      @ip += 4
    end
  end

  def op1; memory[ip + 1] ; end  
  def op2; memory[ip + 2] ; end  
  def res; memory[ip + 3] ; end  
end

if __FILE__ == $0
  puts Intcode.noun_verb(12,2)
  desired = (ARGV.shift || 19690720).to_i
  0.upto(99) do |noun|
    0.upto(99) do |verb|
      puts 100 * noun + verb if Intcode.noun_verb(noun, verb) == desired
    end
  end
end
