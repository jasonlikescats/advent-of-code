module ShipComputer
    require './instructions.rb'

    class ProgramProcessor
        def initialize(intcodes)
            @instruction_pointer = 0
            @memory = intcodes.map(&:clone)
            @input_queue = Queue.new
            @output_queue = Queue.new
        end

        def queue_input(input)
            @input_queue << input
        end

        def read_output
            @output_queue.pop
        end

        def execute
            @thread = Thread.new { execution_loop }
        end

        def halted?
            !@thread.alive?
        end

        private

        def execution_loop
            loop do
                instruction = parse_next_instruction
                instruction.execute
                @instruction_pointer = instruction.updated_instruction_pointer
                
                break if instruction.halt?
            end
        end

        def parse_next_instruction()
            opcode_and_modes = @memory[@instruction_pointer]
            opcode = (opcode_and_modes.to_s[-2..-1] || opcode_and_modes).to_i

            case opcode
            when 1
                AddInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 2
                MultiplyInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 3
                StoreInstruction.new(opcode_and_modes, @instruction_pointer, @memory, get_next_input)
            when 4
                LoadInstruction.new(opcode_and_modes, @instruction_pointer, @memory, method(:add_output))
            when 5
                JumpIfTrueInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 6
                JumpIfFalseInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 7
                LessThanInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 8
                EqualsInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 99
                HaltInstruction.new(opcode_and_modes, @instruction_pointer)
            end
        end

        def get_next_input
            val = @input_queue.pop
            val
        end

        def add_output output
            @output_queue << output
        end
    end
end
