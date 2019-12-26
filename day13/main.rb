require "csv"
require "./game.rb"

module Day13
    def self.part1(intcodes)
        game = Game.new(intcodes)
        game.run

        game.tiles.values.reduce(0) do |sum, row_cells|
            sum + row_cells.count { |cell_num,val| val == Game::BLOCK }
        end
    end

    def self.part2(intcodes)
        intcodes[0] = 2 # play for free

        game = Game.new(intcodes)
        game.run

        # TODO: win the game!

        game.score
    end
end

#intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
#puts "Part 1: " + Day13.part1(intcodes).to_s

intcodes = CSV.parse(File.read("input.txt"))[0].map { |x| x.to_i }
puts "Part 2:\n" + Day13.part2(intcodes).to_s
