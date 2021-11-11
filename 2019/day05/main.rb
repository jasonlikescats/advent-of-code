require "csv"
require "./ship_computer.rb"

module Day05
    def self.part1(intcodes)
        outputs = []

        input_source = lambda { 1 }
        output_sink = lambda { |x| outputs << x }

        computer = ShipComputer::ProgramProcessor.new(intcodes, input_source, output_sink)
        computer.execute

        if outputs[0..-2].any? { |o| o != 0 }
            puts "!!! Failed diagnostic !!!"
            puts outputs.inspect
        end

        outputs[-1]
    end

    def self.part2(intcodes)
        output = nil

        input_source = lambda { 5 }
        output_sink = lambda { |x| output = x }

        computer = ShipComputer::ProgramProcessor.new(intcodes, input_source, output_sink)
        computer.execute

        output
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day05.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day05.part2(intcodes).to_s
