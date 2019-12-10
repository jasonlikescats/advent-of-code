require "csv"

module Day06
    def self.count_orbits(object, orbits, ancestor_count)
        orbiters = orbits
            .find_all { |o| o[0] == object }
            .map { |o| o[1] }

        child_counts = orbiters
            .map { |orbiter| count_orbits(orbiter, orbits, ancestor_count + 1) }
            .reduce(0, :+)

        ancestor_count + child_counts
    end

    def self.part1(input_file)
        orbits = File
            .readlines(input_file)
            .map { |line| line.strip }
            .map { |line| line.split ")" }

        count_orbits("COM", orbits, 0)
    end

    def self.part2()
    end
end

puts "Part 1: " + Day06.part1("input.txt").to_s
puts "Part 2: " + Day06.part2().to_s
