require "file"
require "./memory_game"

def load_input
  File.read("input").split(',').map(&.to_i)
end

def part1
  MemoryGame.new(load_input).play(2020)
end

def part2
  data = load_input
  
  MemoryGame.new(load_input).play(30000000)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
