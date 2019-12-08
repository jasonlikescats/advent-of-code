module ShipComputer
    require './parameters.rb'

    class Instruction
        def initialize(opcode, instruction_address, memory, input_param_count, output_param_count)
            opcode_size = 1
            
            @instruction_address = instruction_address
            @instruction_size = opcode_size + input_param_count + output_param_count

            param_modes = Parameters.parse_modes(opcode, input_param_count)

            @input_params = Array.new(input_param_count) {
                |i| Parameters.create_input_parameter(
                    param_modes[i],
                    memory,
                    instruction_address + opcode_size + i)
            }

            @output_params = Array.new(output_param_count) {
                |i| Parameters.create_output_parameter(
                    memory,
                    instruction_address + opcode_size + input_param_count + i)
            }
        end

        def halt?
            false
        end

        def updated_instruction_pointer
            @instruction_address + @instruction_size
        end
    end

    class HaltInstruction < Instruction
        def initialize(opcode, instruction_address)
            super(opcode, instruction_address, nil, 0, 0)
        end

        def execute
        end

        def halt?
            true
        end
    end

    class AddInstruction < Instruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2, 1)
        end

        def execute
            result = @input_params[0].value + @input_params[1].value
            @output_params[0].set_value result
        end
    end

    class MultiplyInstruction < Instruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2, 1)
        end

        def execute
            result = @input_params[0].value * @input_params[1].value
            @output_params[0].set_value result
        end
    end

    class StoreInstruction < Instruction
        def initialize(opcode, instruction_address, memory, input)
            super(opcode, instruction_address, memory, 0, 1)
            @input = input
        end

        def execute
            @output_params[0].set_value @input
        end
    end

    class LoadInstruction < Instruction
        def initialize(opcode, instruction_address, memory, output_sink)
            super(opcode, instruction_address, memory, 1, 0)
            @output_sink = output_sink
        end

        def execute
            @output_sink.call(@input_params[0].value)
        end
    end

    class BaseJumpInstruction < Instruction
        def initialize(opcode, instruction_address, memory, input_param_count)
            super(opcode, instruction_address, memory, input_param_count, 0)
        end

        def execute
            @perform_jump = should_jump
            @destination_pointer = jump_address
        end

        def updated_instruction_pointer
            @perform_jump ? jump_address : super
        end
    end

    class JumpIfTrueInstruction < BaseJumpInstruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2)
        end

        def should_jump
            @input_params[0].value != 0
        end

        def jump_address
            @input_params[1].value
        end
    end

    class JumpIfFalseInstruction < BaseJumpInstruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2)
        end

        def should_jump
            @input_params[0].value == 0
        end

        def jump_address
            @input_params[1].value
        end
    end

    class LessThanInstruction < Instruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2, 1)
        end

        def execute
            less_than = @input_params[0].value < @input_params[1].value
            @output_params[0].set_value(less_than ? 1 : 0)
        end
    end

    class EqualsInstruction < Instruction
        def initialize(opcode, instruction_address, memory)
            super(opcode, instruction_address, memory, 2, 1)
        end

        def execute
            equals = @input_params[0].value == @input_params[1].value
            @output_params[0].set_value(equals ? 1 : 0)
        end
    end
end
