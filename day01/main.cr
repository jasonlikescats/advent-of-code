require "file"

def load_input
  File.read_lines("input").map(&.to_i)
end

def find_entry_groups_summing(expenses, group_count, target_sum)
  expenses
    .permutations(group_count)
    .find { |permutation| permutation.sum == target_sum }
end

def part1
  expenses = load_input

  entries = find_entry_groups_summing(expenses, 2, 2020)
  entries.try &.product
end

def part2
  expenses = load_input

  entries = find_entry_groups_summing(expenses, 3, 2020)
  entries.try &.product
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
