require "csv"
require "./ship_computer.rb"

module Day09
    def self.part1(intcodes)
        computer = ShipComputer::ProgramProcessor.new(intcodes)
        computer.queue_input(1)
        computer.execute
        
        output = []
        while out = computer.read_output
            output << out
        end
        output
    end

    def self.part2(intcodes)
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day09.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day09.part2(intcodes).to_s
