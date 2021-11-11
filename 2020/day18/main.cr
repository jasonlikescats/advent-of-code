require "file"
require "./expression_parser"

def load_input
  File
    .read("input")
    .delete(' ')
    .split('\n')
end

def solve(precedence_comparer, equation)
  ExpressionParser
    .to_tree(equation, precedence_comparer)
    .evaluate
end

def create_solver(precedence_comparer)
  ->solve((Char, Char) -> Bool, String).partial(precedence_comparer)
end

def part1
  precedence_comparer = ->(_token : Char, _stack : Char) { true } # '+' and '*' have equal precedence
  solver = create_solver(precedence_comparer)
  load_input.map(&solver).sum
end

def part2
  precedence_comparer = ->(token : Char, stack : Char) do
    return true if token == stack

    token == '*' && stack == '+'
  end
  solver = create_solver(precedence_comparer)
  load_input.map(&solver).sum
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
