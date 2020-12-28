require "file"
require "./cube_grid"

def load_input
  CubeGrid.new(File.read("input"))
end

def part1
  grid = load_input

  6.times { grid.step_simulation }

  grid.active_count
end

def part2
  data = load_input

  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
