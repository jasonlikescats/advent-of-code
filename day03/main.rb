require "csv"

module Day03
    class Coordinate
        def initialize(x, y)
            @x, @y = x, y
        end

        def manhattan_distance_from_origin
            @x.abs + @y.abs
        end

        attr_reader :x
        attr_reader :y
    end

    class LineSegment
        def initialize(head, tail)
            @head, @tail = head, tail
        end

        attr_reader :head
        attr_reader :tail

        def vertical?
            @head.x == @tail.x
        end

        def horizontal?
            @head.y == @tail.y
        end

        def self.intersect_at(line1, line2)
            return nil if line1.vertical? && line2.vertical?
            return nil if line1.horizontal? && line2.horizontal?

            horizontal = line1.horizontal? ? line1 : line2
            vertical = line1.vertical? ? line1 : line2

            vert_x = vertical.head.x
            hori_y = horizontal.head.y

            x_in_range =
                vert_x < [horizontal.head.x, horizontal.tail.x].max &&
                vert_x > [horizontal.head.x, horizontal.tail.x].min
            y_in_range =
                hori_y < [vertical.head.y, vertical.tail.y].max &&
                hori_y > [vertical.head.y, vertical.tail.y].min

            return nil if !x_in_range || !y_in_range

            Coordinate.new(vert_x, hori_y)
        end
    end

    def self.get_line_segments(wire_path)
        segments = []
        for step in wire_path
            start = segments.empty? ? Coordinate.new(0, 0) : segments.last().tail
            segments.push(
                segment_builder(start, step))
        end
        segments
    end

    def self.segment_builder(start, step)
        LineSegment.new(
            start,
            coordinate_builder(start, step[0], step[1..].to_i))
    end

    def self.coordinate_builder(start, direction, offset)
        case direction
        when 'R'
            Coordinate.new(start.x + offset, start.y)
        when 'L'
            Coordinate.new(start.x - offset, start.y)
        when 'U'
            Coordinate.new(start.x, start.y + offset)
        when 'D'
            Coordinate.new(start.x, start.y - offset)
        end
    end

    def self.find_intersection_points(segments1, segments2)
        intersections = []
        for seg1_elem in segments1
            for seg2_elem in segments2
                coord = LineSegment.intersect_at(seg1_elem, seg2_elem)
                if coord != nil 
                    intersections.push(coord)
                end
            end
        end
        intersections
    end

    def self.part1(wire1_path, wire2_path)
        wire1_segments = get_line_segments(wire1_path)
        wire2_segments = get_line_segments(wire2_path)

        intersections = find_intersection_points(wire1_segments, wire2_segments)
        distances = intersections.map { |coord| coord.manhattan_distance_from_origin }

        distances.min
    end

    def self.part2(wire1_path, wire2_path)
        ""
    end
end


parsed = CSV.parse(File.read("input.txt"))
wire1_path = parsed[0]
wire2_path = parsed[1]

puts "Part 1: " + Day03.part1(wire1_path, wire2_path).to_s
puts "Part 2: " + Day03.part2(wire1_path, wire2_path).to_s
