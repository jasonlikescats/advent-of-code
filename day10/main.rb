module Day10
    def self.parse_map(asteroid_map)
        asteroids = {}
        asteroid_map.each_with_index do |row, row_index|
            row.each_char.each_with_index do |cell, col_index|
                if cell == "#"
                    asteroids[[col_index,row_index]] = []
                end
            end
        end
        asteroids
    end

    def self.distance(a, b)
        Math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
    end

    def self.occludes(origin, target, candidate)
        direct_dist = distance(origin, target)
        segmented_dist = distance(origin, candidate) + distance(candidate, target)

        is_close(direct_dist, segmented_dist)
    end

    def self.is_close(a, b)
        epsilon = 0.0001
        difference = a - b
        -epsilon < difference && difference < epsilon
    end

    def self.target_is_visible(origin, target, asteroids_coords)
        has_occluder = asteroids_coords
            .filter { |a| a != target }
            .any? { |occlusion_candidate| occludes(origin, target, occlusion_candidate) }

        !has_occluder
    end

    def self.part1(asteroid_map)
        asteroid_visibilities = parse_map(asteroid_map)

        asteroid_visibilities.each do |coords, visible_asteroids|
            other_coords = asteroid_visibilities.keys.filter { |c| c != coords }
            other_coords.each do |visible_candidate_coords|
                visible = target_is_visible(coords, visible_candidate_coords, other_coords)
                visible_asteroids << visible_candidate_coords if visible
            end
        end

        asteroid_visibilities
            .max_by { |coord, visible_list| visible_list.length }[1]
            .length
    end

    def self.part2(asteroid_map)
    end
end

asteroid_map = File.readlines("input.txt")

puts "Part 1: " + Day10.part1(asteroid_map).to_s
puts "Part 2:\n" + Day10.part2(asteroid_map).to_s
