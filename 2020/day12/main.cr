require "file"
require "./naive_ship"
require "./waypointed_ship"

struct Instruction
  getter direction : Char, magnitude : Int32

  def initialize(instruction)
    @direction = instruction[0]
    @magnitude = instruction[1..].to_i
  end
end

def load_input
  File.read_lines("input").map(&->Instruction.new(String))
end

def manhattan_distance(ship)
  ship.east_west_position.abs + ship.north_south_position.abs
end

def part1
  ship = NaiveShip.new
  load_input.each(&->ship.apply_instruction(Instruction))
  manhattan_distance(ship)
end

def part2
  ship = WaypointedShip.new(10, 1)
  load_input.each(&->ship.apply_instruction(Instruction))
  manhattan_distance(ship)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
