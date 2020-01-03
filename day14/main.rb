require "csv"

module Day14
    class Component
        def initialize(chemical, count)
            @chemical, @count = chemical, count
        end

        attr_reader :chemical
        attr_reader :count
    end

    def self.reactions_from_input(lines)
        lines
            .map { |line| line.scan /[ ]*([\d]*) ([\w]+)/ }
            .map { |line_matches|
                components = line_matches.map { |match| Component.new(match[1], match[0]) }
                [ components[-1], components[ 0..-2 ] ]
            }
    end

    def self.part1(reactions)
        
    end

    def self.part2(reactions)
        "TODO"
    end
end

reactions = Day14.reactions_from_input(File.readlines("input.txt"))
puts "Part 1: " + Day14.part1(reactions).to_s
puts "Part 2: " + Day14.part2(reactions).to_s
