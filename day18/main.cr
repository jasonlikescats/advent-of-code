require "file"
require "./expression_parser"

def load_input
  File
    .read("input")
    .delete(' ')
    .split('\n')
end

def solve(equation)
  ExpressionParser
    .to_tree(equation)
    .evaluate
end

def part1
  equations = load_input
  equations.map(&->solve(String)).sum
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
