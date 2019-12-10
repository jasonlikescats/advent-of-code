module ShipComputer
    require './instructions.rb'

    class ProgramProcessor
        def initialize(intcodes, inputs, output_sink)
            @instruction_pointer = 0
            @memory = intcodes
            @input_source = input_sequence inputs
            @output_sink = output_sink
        end

        def execute()
            loop do
                instruction = parse_next_instruction
                instruction.execute
                @instruction_pointer = instruction.updated_instruction_pointer
                
                break if instruction.halt?
            end
        end

        private

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
                LoadInstruction.new(opcode_and_modes, @instruction_pointer, @memory, @output_sink)
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

        def input_sequence inputs
            Enumerator.new do |enum|
                for input in inputs
                    enum.yield input
                end
            end
        end

        def get_next_input
            @input_source.next
        end
    end
end
