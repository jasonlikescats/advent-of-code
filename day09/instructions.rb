module ShipComputer
    require './parameters.rb'

    class Instruction
        def initialize(base_params, input_param_count, output_param_count)
            opcode = base_params[:opcode]
            relative_base = base_params[:relative_base]
            memory = base_params[:memory]
            
            @instruction_address = base_params[:instruction_address]
            opcode_size = 1
            parameter_count = input_param_count + output_param_count
            @instruction_size = opcode_size + parameter_count

            param_modes = Parameters.parse_modes(opcode, parameter_count)

            @input_params = Array.new(input_param_count) {
                |i| Parameters.create_parameter(
                    param_modes[i],
                    memory,
                    relative_base,
                    @instruction_address + opcode_size + i)
            }

            @output_params = Array.new(output_param_count) {
                |i| Parameters.create_parameter(
                    param_modes[i + input_param_count],
                    memory,
                    relative_base,
                    @instruction_address + opcode_size + input_param_count + i)
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
        def initialize(base_params)
            super(base_params, 0, 0)
        end

        def execute
        end

        def halt?
            true
        end
    end

    class AddInstruction < Instruction
        def initialize(base_params)
            super(base_params, 2, 1)
        end

        def execute
            result = @input_params[0].value + @input_params[1].value
            @output_params[0].set_value result
        end
    end

    class MultiplyInstruction < Instruction
        def initialize(base_params)
            super(base_params, 2, 1)
        end

        def execute
            result = @input_params[0].value * @input_params[1].value
            @output_params[0].set_value result
        end
    end

    class StoreInstruction < Instruction
        def initialize(base_params, input)
            super(base_params, 0, 1)
            @input = input
        end

        def execute
            @output_params[0].set_value @input
        end
    end

    class LoadInstruction < Instruction
        def initialize(base_params, output_sink)
            super(base_params, 1, 0)
            @output_sink = output_sink
        end

        def execute
            @output_sink.call(@input_params[0].value)
        end
    end

    class BaseJumpInstruction < Instruction
        def initialize(base_params, input_param_count)
            super(base_params, input_param_count, 0)
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
        def initialize(base_params)
            super(base_params, 2)
        end

        def should_jump
            @input_params[0].value != 0
        end

        def jump_address
            @input_params[1].value
        end
    end

    class JumpIfFalseInstruction < BaseJumpInstruction
        def initialize(base_params)
            super(base_params, 2)
        end

        def should_jump
            @input_params[0].value == 0
        end

        def jump_address
            @input_params[1].value
        end
    end

    class LessThanInstruction < Instruction
        def initialize(base_params)
            super(base_params, 2, 1)
        end

        def execute
            less_than = @input_params[0].value < @input_params[1].value
            @output_params[0].set_value(less_than ? 1 : 0)
        end
    end

    class EqualsInstruction < Instruction
        def initialize(base_params)
            super(base_params, 2, 1)
        end

        def execute
            equals = @input_params[0].value == @input_params[1].value
            @output_params[0].set_value(equals ? 1 : 0)
        end
    end

    class RelativeBaseAdjustmentInstruction < Instruction
        def initialize(base_params, relative_base_output_sink)
            super(base_params, 1, 0)
            @relative_base = base_params[:relative_base]
            @relative_base_output_sink = relative_base_output_sink
        end

        def execute
            puts "RELBASE: #{@relative_base}, #{@input_params[0].value}"
            new_base = @relative_base + @input_params[0].value
            @relative_base_output_sink.call(new_base)
        end
    end
end
