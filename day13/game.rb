require "./renderer.rb"
require "./ship_computer.rb"

module Day13
    class Game
        EMPTY = 0
        WALL = 1
        BLOCK = 2
        PADDLE = 3
        BALL = 4

        def initialize(intcodes)
            @computer = ShipComputer::ProgramProcessor.new(intcodes)
            @computer.execute

            @tiles = Hash.new { |hash, key| hash[key] = Hash.new }
            @inputs = []
        end

        attr_reader :tiles
        attr_reader :score

        def run
            @renderer = CursesRenderer.new(24, 36, method(:render_cell))
            #@renderer = ConsoleRenderer.new(method(:render_cell)) 

            loop do
                outputs = handle_io

                break if outputs.nil?

                if outputs[0] == -1 && outputs[1] == 0
                    @score = outputs[2]
                else
                    cell, row = outputs[0], outputs[1]
                    tile = outputs[2]

                    @paddle_x = cell if tile == PADDLE
                    @ball_x = cell if tile == BALL

                    tiles[row][cell] = tile
                end

                @renderer.refresh(tiles)
            end
            
            @renderer.teardown
            puts "INPUTS: #{@inputs}"
        end

        private

        def handle_io
            loop do
                if @computer.awaiting_input?
                    inpt = calculate_input
#                    puts "QUEUEING INPUT #{inpt}"
                    @inputs << inpt
                    @computer.queue_input(inpt)
                end

                output = @computer.read_output(non_block: true)
                return [
                    output,
                    @computer.read_output,
                    @computer.read_output
                ] if output != nil
                
                return nil if @computer.halted?
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