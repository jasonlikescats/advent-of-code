require "csv"
require "./ship_computer.rb"

module Day07
    def self.run_amplifier_controller(intcodes, input_phase_setting, input_signal)
        output = nil
        memory = intcodes.map(&:clone)
        inputs = [input_phase_setting, input_signal]
        output_sink = lambda { |x| output = x }

        computer = ShipComputer::ProgramProcessor.new(memory, inputs, output_sink)
        computer.execute

        output
    end

    def self.run_amplifier_chain(intcodes, input_phases)
        output = nil;
        input_signal = 0;
        for phase in input_phases
            output = run_amplifier_controller(intcodes, phase, input_signal)
            input_signal = output
        end

        output
    end

    def self.part1(intcodes)
        phase_values = [0, 1, 2, 3, 4]
        phase_candidates = phase_values.permutation.to_a

        phase_candidates
            .map { |c| run_amplifier_chain(intcodes, c) }
            .max
    end

    def self.part2(intcodes)
        "Incomplete"
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day07.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day07.part2(intcodes).to_s
