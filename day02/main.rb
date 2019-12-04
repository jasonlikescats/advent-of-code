require "csv"

module Day02
    class ProgramRunner
        def initialize(intcodes)
            @program_counter = 0
            @intcodes = intcodes
        end

        def run()
            while (!check_for_halt(@intcodes[@program_counter]))
                operation = get_operation(@intcodes[@program_counter])
                execute(
                    operation,
                    @intcodes[@program_counter+1],
                    @intcodes[@program_counter+2],
                    @intcodes[@program_counter+3])
                @program_counter += 4
            end
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

    def self.run_with_inputs(intcodes, noun, verb)
        intcodes[1] = noun
        intcodes[2] = verb

        runner = ProgramRunner.new(intcodes)
        runner.run()

        intcodes[0]
    end

    def self.part1(intcodes)
        # setup 1202 program alarm state
        noun = 12
        verb = 2
        run_with_inputs(intcodes, noun, verb)
    end

    def self.part2(intcodes)
        target_output = 19690720

        for noun in 0..99 do
            for verb in 0..99 do
                output = run_with_inputs(intcodes.map(&:clone), noun, verb)
                if output == target_output
                    return 100 * noun + verb
                end
            end
        end
        -1
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day02.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day02.part2(intcodes).to_s
