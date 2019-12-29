require "./renderer.rb"
require "./ship_computer.rb"

module Day13
    class Game
        EMPTY = 0
        WALL = 1
        BLOCK = 2
        PADDLE = 3
        BALL = 4

        def initialize(intcodes, render_type)
            @computer = ShipComputer::ProgramProcessor.new(intcodes)
            @computer.execute

            @tiles = Hash.new { |hash, key| hash[key] = Hash.new }
            init_renderer(render_type)
        end

        attr_reader :tiles
        attr_reader :score

        def run
            loop do
                output = @computer.read_output
                case output
                when :halted
                    break
                when :await_input
                    @computer.queue_input(calculate_input)
                    next
                else
                    handle_program_output [
                        output,
                        @computer.read_output,
                        @computer.read_output]
                end

                @renderer.refresh(tiles)
            end
            
            @renderer.teardown
        end

        private

        def init_renderer(render_type)
            case render_type
            when :curses
                @renderer = CursesRenderer.new(method(:render_cell))
            when :console
                @renderer = ConsoleRenderer.new(method(:render_cell)) 
            when :none
                @renderer = NullRenderer.new
            end
        end

        def handle_program_output(triplet)
            if triplet[0] == -1 && triplet[1] == 0
                @score = triplet[2]
            else
                cell, row = triplet[0], triplet[1]
                tile = triplet[2]

                @paddle_x = cell if tile == PADDLE
                @ball_x = cell if tile == BALL

                tiles[row][cell] = tile
            end
        end

        def calculate_input
            return 0 if @paddle_x.nil? || @ball_x.nil?
            delta_direction = -(@paddle_x <=> @ball_x)

            delta_direction
        end

        def render_cell(value)
            case value
            when EMPTY
                " "
            when WALL
                "#"
            when BLOCK
                "-"
            when PADDLE
                "_"
            when BALL
                "o"
            end
        end
    end
end