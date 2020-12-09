class Bootloader
  struct ProgramState
    getter accumulator : Int32, program_counter : Int32

    def self.start_state
      new(0, 0)
    end

    def initialize(@accumulator, @program_counter)
    end
  end

  abstract class Instruction
    def self.parse(instruction_data)
      type = instruction_data[0..2]
      arg = instruction_data[4..].to_i

      case type
      when "acc"
        AccInstruction.new(arg)
      when "jmp"
        JmpInstruction.new(arg)
      when "nop"
        NopInstruction.new(arg)
      else
        raise "Unknown instruction type"
      end
    end

    getter arg : Int32

    def initialize(@arg)
    end

    abstract def execute(state)
  end

  class AccInstruction < Instruction
    def execute(state)
      ProgramState.new(state.accumulator + arg, state.program_counter + 1)
    end
  end

  class JmpInstruction < Instruction
    def execute(state)
      ProgramState.new(state.accumulator, state.program_counter + arg)
    end
  end

  class NopInstruction < Instruction
    def execute(state)
      ProgramState.new(state.accumulator, state.program_counter + 1)
    end
  end

  getter state : ProgramState
  private setter state : ProgramState

  private getter instructions : Array(Instruction)

  def initialize(instructions_data)
    @state = ProgramState.start_state
    @instructions = instructions_data.map(&->Instruction.parse(String))
  end

  def step
    raise "Terminated" if terminated?

    @state = next_instruction.not_nil!.execute(state)
  end

  def next_instruction
    return nil if terminated?

    instructions[state.program_counter]
  end

  def terminated?
    state.program_counter >= instructions.size
  end
end
