require "file"

struct Instruction
  getter direction : Char, magnitude : Int32

  def initialize(instruction)
    @direction = instruction[0]
    @magnitude = instruction[1..].to_i
  end
end

class Ship
  # positions relative to start
  getter east_west_position : Int32, north_south_position : Int32
  getter direction

  def initialize
    @east_west_position = 0
    @north_south_position = 0
    @direction = 'E'
  end

  def apply_instruction(instruction)
    if ['L', 'R'].includes?(instruction.direction)
      apply_turn(instruction)
    else
      apply_move(instruction)
    end
  end

  def log_position
    east_west = "#{east_west_position >= 0 ? "east" : "west"} #{east_west_position.abs}"
    north_south = "#{north_south_position >= 0 ? "north" : "south"} #{north_south_position.abs}"
    facing = case direction
             when 'N' then "north"
             when 'E' then "east"
             when 'S' then "south"
             when 'W' then "west"
             end
    puts "#{east_west}, #{north_south} (facing #{facing})"
  end

  private def apply_turn(instruction)
    turn_count = instruction.magnitude / 90

    sequence = ['N', 'E', 'S', 'W']
    sequence.reverse! if instruction.direction == 'L'

    start = sequence.index(direction).not_nil!
    resultant = (start + turn_count).to_i % sequence.size
    @direction = sequence[resultant]
  end

  private def apply_move(instruction)
    if instruction.direction == 'F'
      move_in_direction(direction, instruction.magnitude)
    else
      move_in_direction(instruction.direction, instruction.magnitude)
    end
  end

  private def move_in_direction(direction, magnitude)
    case direction
    when 'N'
      @north_south_position += magnitude
    when 'S'
      @north_south_position -= magnitude
    when 'E'
      @east_west_position += magnitude
    when 'W'
      @east_west_position -= magnitude
    end
  end
end

def load_input
  File.read_lines("input").map(&->Instruction.new(String))
end

def part1
  instructions = load_input
  ship = Ship.new

  instructions.each(&->ship.apply_instruction(Instruction))

  ship.east_west_position.abs + ship.north_south_position.abs
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
