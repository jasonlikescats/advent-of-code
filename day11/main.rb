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
        def initialize(intcodes)
            @computer = ShipComputer::ProgramProcessor.new(intcodes)
            @computer.execute

            @orientation = Orientation.new
            @painted = {}
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

        BLACK = 0

        def paint_color_at_current_location
            @painted.fetch(@orientation.location.to_tuple, BLACK)
        end

        def paint(color)
            @painted[@orientation.location.to_tuple] = color
        end

        LEFT_TURN = 0
        RIGHT_TURN = 1

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
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day11.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2: " + Day11.part2(intcodes).to_s
