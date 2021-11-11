require "file"
require "./policy_evaluator"

def load_input
  File.read_lines("input")
end

def load_policy_evaluators(policy_creator)
  load_input.map { |line| parse_input(line, policy_creator) }
end

def parse_input(line, policy_creator)
  pattern = /(\d+)-(\d+) (.): (\w+)/
  result = pattern.match(line).not_nil!

  policy = policy_creator.call(
    result[1].to_u8,
    result[2].to_u8,
    result[3][0])
  PolicyEvaluator.new(policy, result[4])
end

def part1
  policy_creator = ->SledRentalPolicy.new(UInt8, UInt8, Char)
  policy_evaluators = load_policy_evaluators(policy_creator)
  policy_evaluators.count(&.valid?)
end

def part2
  policy_creator = ->TobogganRentalPolicy.new(UInt8, UInt8, Char)
  policy_evaluators = load_policy_evaluators(policy_creator)
  policy_evaluators.count(&.valid?)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
