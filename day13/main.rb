require "csv"
require "./ship_computer.rb"

module Day13
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

    class Game
        EMPTY = 0
        WALL = 1
        BLOCK = 2
        PADDLE = 3
        BALL = 4

        def initialize(intcodes)
            @computer = ShipComputer::ProgramProcessor.new(intcodes)
            @computer.execute

            @tiles = Hash.new
        end

        attr_reader :tiles
        attr_reader :score

        def run
            loop do
                outputs = [
                    @computer.read_output,
                    @computer.read_output,
                    @computer.read_output
                ]

                break unless outputs.any?

                if outputs[0] == -1 && outputs[1] == 0
                    @score = outputs[2]
                else
                    tiles[[outputs[0], outputs[1]]] = outputs[2]
                end
            end
        end
    end

    def self.part1(intcodes)
        game = Game.new(intcodes)
        game.run

        game.tiles.values.count{ |t| t == Game::BLOCK }
    end

    def self.part2(intcodes)
        intcodes[0] = 2 # play for free

        game = Game.new(intcodes)
        game.run

        # TODO: win the game!

        game.score
    end
end

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 1: " + Day13.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2:\n" + Day13.part2(intcodes).to_s
