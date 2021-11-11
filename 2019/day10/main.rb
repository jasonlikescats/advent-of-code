module Day10
    def self.parse_map(asteroid_map, initializer)
        asteroids = {}
        asteroid_map.each_with_index do |row, row_index|
            row.each_char.each_with_index do |cell, col_index|
                if cell == "#"
                    asteroids[[col_index,row_index]] = initializer.call
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

    def self.find_best_location(asteroid_map)
        asteroid_visibilities = parse_map(asteroid_map, lambda { [] })

        asteroid_visibilities.each do |coords, visible_asteroids|
            other_coords = asteroid_visibilities.keys.filter { |c| c != coords }
            other_coords.each do |visible_candidate_coords|
                visible = target_is_visible(coords, visible_candidate_coords, other_coords)
                visible_asteroids << visible_candidate_coords if visible
            end
        end

        asteroid_visibilities.max_by { |coord, visible_list| visible_list.length }
    end

    def self.part1(location_and_visible_asteroids)
        location_and_visible_asteroids[1].length
    end

    def self.angle_relative_to(origin, point)
        atan = Math.atan2(origin[1] - point[1], origin[0] - point[0])

        # adjust to "up" being the origin axis (atan2 is "right" as origin)
        if atan < Math::PI/2
            angle = atan + 3*Math::PI/2
        else
            angle = atan - Math::PI/2
        end

        angle
    end

    def self.part2(asteroid_map, monitoring_location)
        asteroids = parse_map(asteroid_map, lambda { 0 }).keys

        angle_sorted_groups = asteroids
            .filter { |coord| coord != monitoring_location }
            .group_by { |coord| angle_relative_to(monitoring_location, coord) }
            .sort_by { |angle, _coll| angle }
            .to_h

        angle_sorted_groups.each { |angle, coords|
            angle_sorted_groups[angle] = coords.sort_by {|c| distance(monitoring_location, c)}
        }
        
        destructions = []
        loop do
            angle_sorted_groups.each do |angle, coords|
                if coords != nil
                    destructions << coords.shift
                end
            end

            break if angle_sorted_groups.all? { |angle, coords| coords == nil || coords.length == 0 }
        end

        two_hundredth = destructions[199]
        two_hundredth[0]*100 + two_hundredth[1]
    end
end

asteroid_map = File.readlines("input.txt")

monitoring_station = Day10.find_best_location(asteroid_map)
puts "Part 1: " + Day10.part1(monitoring_station).to_s
puts "Part 2: " + Day10.part2(asteroid_map, monitoring_station[0]).to_s