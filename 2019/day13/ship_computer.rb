module ShipComputer
    require './instructions.rb'
    require './virtual_memory.rb'

    class ProgramProcessor
        def initialize(intcodes)
            @instruction_pointer = 0
            @relative_base = 0
            @memory = VirtualMemory.new
            @memory.memcpy(0, intcodes)
            @input_queue = Queue.new
            @output_queue = Queue.new
        end

        def queue_input(input)
            @input_queue << input
        end

        # Produces either raw output from the program being
        # computed, or a symbol denoting meta state about the
        # computer. Meta states that may be emitted are:
        # - :halted (indicating processing is complete)
        # - :await_input (indicating processing is about to
        #   block on the input queue)
        def read_output
            @output_queue.pop
        end

        def execute
            @thread = Thread.new { execution_loop }
        end

        private

        def execution_loop
            loop do
                instruction = parse_next_instruction
                instruction.execute
                @instruction_pointer = instruction.updated_instruction_pointer
                
                break if instruction.halt?
            end
            add_output :halted
        end

        def parse_next_instruction()
            opcode_and_modes = @memory[@instruction_pointer]
            opcode = (opcode_and_modes.to_s[-2..-1] || opcode_and_modes).to_i

            base_params = build_base_params(
                opcode_and_modes,
                @relative_base,
                @instruction_pointer,
                @memory
            )

            case opcode
            when 1
                AddInstruction.new(base_params)
            when 2
                MultiplyInstruction.new(base_params)
            when 3
                StoreInstruction.new(base_params, get_next_input)
            when 4
                LoadInstruction.new(base_params, method(:add_output))
            when 5
                JumpIfTrueInstruction.new(base_params)
            when 6
                JumpIfFalseInstruction.new(base_params)
            when 7
                LessThanInstruction.new(base_params)
            when 8
                EqualsInstruction.new(base_params)
            when 9
                RelativeBaseAdjustmentInstruction.new(base_params, method(:update_relative_base))
            when 99
                HaltInstruction.new(base_params)
            end
        end

        def build_base_params(opcode, relative_base, instruction_pointer, memory)
            {
                :opcode => opcode,
                :relative_base => relative_base,
                :instruction_address => instruction_pointer,
                :memory => memory
            }
        end

        def get_next_input
            add_output :await_input
            @input_queue.pop
        end

        def add_output output
            @output_queue << output
        end

        def update_relative_base value
            @relative_base = value
        end
    end
end
