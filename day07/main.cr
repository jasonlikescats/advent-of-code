require "file"
require "./bag_rules"

def load_rules
  BagRules.parse(File.read_lines("input"))
end

def part1
  load_rules.count_allowed_containers("shiny gold")
end

def part2
  load_rules.count_contained_bags("shiny gold")
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
