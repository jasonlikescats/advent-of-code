require "csv"
require "./ship_computer.rb"

module Day07
    def self.start_new_aplifier_controller(intcodes, phase_setting)
        amp = ShipComputer::ProgramProcessor.new(intcodes)
        amp.queue_input phase_setting
        amp.execute
        amp
    end

    def self.create_amp_controllers(intcodes, input_phases)
        input_phases
            .map { |phase| start_new_aplifier_controller(intcodes, phase) }
    end

    def self.run_chain(amp_controllers, input_signal)
        amp_controllers
            .reduce(input_signal) { |signal, amp|
                amp.queue_input signal
                amp.read_output
            }
    end

    def self.run_amplifier_loop(intcodes, input_phases, input_signal)
        amps = create_amp_controllers(intcodes, input_phases)

        signal = input_signal
        while amps.any? { |amp| !amp.halted? }
            output_signal = run_chain(amps, signal)
            signal = output_signal
        end
        signal
    end

    def self.part1(intcodes)
        phase_values = [0, 1, 2, 3, 4]
        phase_candidates = phase_values.permutation.to_a

        phase_candidates
            .map { |c|
                amps =  create_amp_controllers(intcodes, c)
                run_chain(amps, 0)
            }
            .max
    end

    def self.part2(intcodes)
        phase_values = [5, 6, 7, 8, 9]
        phase_candidates = phase_values.permutation.to_a

        phase_candidates
            .map { |c| run_amplifier_loop(intcodes, c, 0) }
            .max
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day07.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day07.part2(intcodes).to_s
