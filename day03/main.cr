require "file"

def load_input
  Map.new(File.read_lines("input"))
end

struct Cartesian2D
  getter x, y

  def initialize(@x : Int32, @y : Int32)
  end

  def +(other : Cartesian2D)
    Cartesian2D.new(x + other.x, y + other.y)
  end
end

class Map
  TREE = '#'

  getter data

  def initialize(@data : Array(String))
  end

  def tree?(position : Cartesian2D)
    at_position(position) == TREE
  end
  
  def bottom_row?(position : Cartesian2D)
    data.size == position.y + 1
  end

  private def at_position(position : Cartesian2D)
    # handle repeating pattern in x
    equivalent_x_pos = position.x % data_width

    data[position.y][equivalent_x_pos]
  end

  private def data_width
    data.first.size
  end
end

def count_trees(map, position, slope)
  count = 0

  next_position = position + slope
  
  count += 1 if map.tree?(next_position)
  count += count_trees(map, next_position, slope) unless map.bottom_row?(next_position)

  count
end

def part1
  map = load_input

  start_position = Cartesian2D.new(0, 0)
  slope = Cartesian2D.new(3, 1)
  count_trees(map, start_position, slope)
end

def part2
  map = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
