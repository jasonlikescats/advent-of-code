require "file"
require "./cube_grid"

def load_input
  File.read("input")
end

def part1
  data = load_input
  grid = CubeGrid.new(data, three_dimensional: true)
  6.times { grid.step_simulation }
  grid.active_count
end

def part2
  data = load_input
  grid = CubeGrid.new(data)
  6.times { grid.step_simulation }
  grid.active_count
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
