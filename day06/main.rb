require "csv"

module Day06
    def self.read_orbitals(input_file)
        File
            .readlines(input_file)
            .map { |line| line.strip }
            .map { |line| line.split ")" }
    end

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
        orbitals = read_orbitals(input_file)
        count_orbits("COM", orbitals, 0)
    end

    def self.path_to_object(object, orbitals, ancestors)
        orbit = orbitals.find { |o| o[1] == object }
        
        if orbit            
            orbiting = orbit[0]
            ancestors.prepend orbiting

            path_to_object(orbiting, orbitals, ancestors)
        end

        ancestors
    end

    def self.path_from_common(arr1, arr2)
        while arr1[0] == arr2[0]
            return path_from_common(arr1[1..], arr2[1..])
        end

        [arr1, arr2]
    end

    def self.part2(input_file)
        orbitals = read_orbitals(input_file)

        you = path_to_object("YOU", orbitals, [])
        san = path_to_object("SAN", orbitals, [])
        path_from_shared = path_from_common(you, san)

        # Distance between YOU and SAN is the sum of the distance to
        # the first shared common ancestor
        path_from_shared[0].count + path_from_shared[1].count
    end
end

puts "Part 1: " + Day06.part1("input.txt").to_s
puts "Part 2: " + Day06.part2("input.txt").to_s
