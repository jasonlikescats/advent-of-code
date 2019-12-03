require "CSV"

module Day02
    class ProgramRunner
        def initialize(intcodes)
            @offset = 0
            @intcodes = intcodes
        end

        def run()
            while (!check_for_halt(@intcodes[@offset]))
                debug_print()
                operation = get_operation(@intcodes[@offset])
                execute(operation, @intcodes[@offset+1], @intcodes[@offset+2], @intcodes[@offset+3])
                @offset += 4
            end

            debug_print()
        end

        def debug_print()
            puts "pc=#{@offset}, memory=#{@intcodes.inspect}"
        end

        private

        def check_for_halt(intcode)
            intcode == 99
        end

        def get_operation(intcode)
            case intcode
            when 1
                Proc.new { | x, y | x + y }
            when 2
                Proc.new { | x, y | x * y }
            end
        end

        def execute(operation, operand1_offset, operand2_offset, result_offset)
            @intcodes[result_offset] = operation.call(
                @intcodes[operand1_offset],
                @intcodes[operand2_offset])
        end
    end

    def self.part1(intcodes)
        # setup 1202 program alarm state
        intcodes[1] = 12
        intcodes[2] = 2

        runner = ProgramRunner.new(intcodes)
        runner.run()

        intcodes[0]
    end

    def self.part2(intcodes)
        
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day02.part1(intcodes).to_s
puts "Part 2: " + Day02.part2(intcodes).to_s
