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

    def self.find_ancestors(object, orbitals, ancestors)
        orbit = orbitals.find { |o| o[1] == object }
        
        if orbit            
            orbiting = orbit[0]
            ancestors.append orbiting

            find_ancestors(orbiting, orbitals, ancestors)
        end

        ancestors
    end

    def self.indices_of_first_shared(arr1, arr2)
        arr1.each_with_index { |elem1, index1|
            index2 = arr2.find_index elem1
            if index2
                return [index1, index2]
            end
        }
    end

    def self.part2(input_file)
        orbitals = read_orbitals(input_file)

        you = find_ancestors("YOU", orbitals, [])
        san = find_ancestors("SAN", orbitals, [])
        indices_of_shared = indices_of_first_shared(you, san)

        # Distance between YOU and SAN is the sum of the distance to
        # the first shared common ancestor
        indices_of_shared[0] + indices_of_shared[1]
    end
end

puts "Part 1: " + Day06.part1("input.txt").to_s
puts "Part 2: " + Day06.part2("input.txt").to_s
