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
            @input_requested_sem = Mutex.new
            @input_requested_count = 0
        end

        def awaiting_input?
            #@input_requested_sem.locked?
            @input_requested_sem.synchronize {
                return @input_requested_count > 0
            }

            # waiting = @input_queue.num_waiting
            # puts "waiting == #{waiting}" if waiting > 0
            # waiting > 0 && @input_queue.empty?
        end

        def halted?
            @output_queue.closed?
        end

        def queue_input(input)
            @input_requested_sem.synchronize {
                if @input_requested_count > 0
                    @input_queue << input
                    @input_requested_count -= 1
#                    puts "QUEUED #{input} (COUNT AFTER = #{@input_requested_count})"
                else
#                    puts "SKIPPING QUEUEING INPUT"
                end
            }
        end

        def read_output(non_block = false)
            return nil if non_block && @output_queue.empty?

            output = @output_queue.pop(non_block)
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
            @output_queue.close
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
            @input_requested_sem.synchronize {
                @input_requested_count += 1
#                puts "AWAITING INPUT (COUNT = #{@input_requested_count})"
            }
            
            inp = @input_queue.pop
#            puts "POPPED INPUT #{inp} (COUNT = #{@input_requested_count})"
            inp
        end

        def add_output output
            @output_queue << output
        end

        def update_relative_base value
            @relative_base = value
        end
    end
end
