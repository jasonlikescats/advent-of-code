module ShipComputer
    require './parameters.rb'

    class Instruction
        def initialize(opcode, instruction_address, memory, input_param_count, output_param_count)
            opcode_offset = 1
            param_modes = Parameters.parse_modes(opcode, input_param_count)

            @input_params = Array.new(input_param_count) {
                |i| Parameters.create_input_parameter(
                    param_modes[i],
                    memory,
                    instruction_address + opcode_offset + i)
            }

            @output_params = Array.new(output_param_count) {
                |i| Parameters.create_output_parameter(
                    memory,
                    instruction_address + opcode_offset + input_param_count + i)
            }
        end

        def halt?
            false
        end
    end

    class HaltInstruction < Instruction
        def initialize(opcode)
            super(opcode, nil, nil, 0, 0)
            @size = 1
        end

        def execute
        end

        def halt?
            true
        end

        def size
            1
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

        def size
            4
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

        def size
            4
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

        def size
            2
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

        def size
            2
        end
    end
end
