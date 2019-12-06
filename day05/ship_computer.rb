module ShipComputer
    require './instructions.rb'

    class ProgramProcessor
        def initialize(intcodes, input_source, output_sink)
            @instruction_pointer = 0
            @memory = intcodes
            @input_source = input_source
            @output_sink = output_sink
        end

        def execute()
            puts "==="
            loop do
                instruction = parse_next_instruction
                instruction.execute
                @instruction_pointer += instruction.size
                puts "==="
                
                break if instruction.halt?
            end
        end

        private

        def parse_next_instruction()
            puts "Inst load addr=#{@instruction_pointer}"

            opcode_and_modes = @memory[@instruction_pointer]
            opcode = (opcode_and_modes.to_s[-2..-1] || opcode_and_modes).to_i

            puts "Opcode=#{opcode_and_modes} (#{opcode})"

            case opcode
            when 1
                AddInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 2
                MultiplyInstruction.new(opcode_and_modes, @instruction_pointer, @memory)
            when 3
                StoreInstruction.new(opcode_and_modes, @instruction_pointer, @memory, @input_source.call)
            when 4
                LoadInstruction.new(opcode_and_modes, @instruction_pointer, @memory, @output_sink)
            when 99
                HaltInstruction.new(opcode_and_modes)
            end
        end
    end
end
