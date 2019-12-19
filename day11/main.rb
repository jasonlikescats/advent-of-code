require "csv"
require "./ship_computer.rb"

module Day11
    class Orientation
        class Coordinate
            def initialize(x, y)
                @x, @y = x, y
            end
    
            attr_accessor :x
            attr_accessor :y

            def to_tuple
                [x, y]
            end
        end

        DIRECTIONS = [ :up, :left, :down, :right ]
    
        def initialize
            @orientation = :up
            @location = Coordinate.new(0,0)
        end
        
        attr_reader :location

        def turn(turn_direction)
            adjustment = turn_direction == :left ? 1 : -1
            adjusted_orientation_index = (DIRECTIONS.index(@orientation) + adjustment) % DIRECTIONS.length
            @orientation = DIRECTIONS[adjusted_orientation_index]
        end

        def move()
            case @orientation
            when :up
                @location.y += 1
            when :left
                @location.x -= 1
            when :down
                @location.y -= 1
            when :right
                @location.x += 1
            end
        end
    end

    class HullPaintingRobot
        BLACK = 0
        WHITE = 1

        def initialize(intcodes, start_panel_color = nil)
            @computer = ShipComputer::ProgramProcessor.new(intcodes)
            @computer.execute

            @orientation = Orientation.new
            @painted = { }
            paint(start_panel_color) if start_panel_color != nil
        end

        attr_reader :painted

        def run
            loop do
                @computer.queue_input(paint_color_at_current_location)
                color_to_paint = @computer.read_output
                turn_direction = @computer.read_output

                break if color_to_paint == nil || turn_direction == nil

                paint(color_to_paint)
                @orientation.turn(to_direction_symbol turn_direction)
                @orientation.move
            end
        end

        private

        LEFT_TURN = 0
        RIGHT_TURN = 1

        def paint_color_at_current_location
            @painted.fetch(@orientation.location.to_tuple, BLACK)
        end

        def paint(color)
            @painted[@orientation.location.to_tuple] = color
        end

        def to_direction_symbol(turn_direction)
            case turn_direction
            when LEFT_TURN
                :left
            when RIGHT_TURN
                :right
            end
        end
    end

    def self.part1(intcodes)
        robot = HullPaintingRobot.new(intcodes)
        robot.run
        robot.painted.length
    end

    def self.part2(intcodes)
        robot = HullPaintingRobot.new(intcodes, HullPaintingRobot::WHITE)
        robot.run
        print_painted_hull(robot.painted)
    end

    def self.print_painted_hull(painted_coords)
        min_x = painted_coords.keys.map{|c| c[0]}.min
        max_x = painted_coords.keys.map{|c| c[0]}.max
        min_y = painted_coords.keys.map{|c| c[1]}.min
        max_y = painted_coords.keys.map{|c| c[1]}.max

        black_panel = " "
        white_panel = "#"

        identifier = ""
        max_y.downto(min_y).each do |y|
            (min_x..max_x).each do |x|
                color = painted_coords.fetch([x,y], HullPaintingRobot::BLACK)
                identifier += color == HullPaintingRobot::BLACK ? black_panel : white_panel
            end
            identifier += "\n"
        end
        identifier
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day11.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2:\n" + Day11.part2(intcodes).to_s
