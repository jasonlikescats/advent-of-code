require "file"

def load_input
  File
    .read_lines("input")
    .map { |line| line.chars.map(&.to_i) }
end

def largest_joltage(digits)
  first, idx = largest_digit_with_index_from(digits[0...-1])
  second, _ = largest_digit_with_index_from(digits[(idx+1)..])
  
  first * 10 + second
end

def largest_digit_with_index_from(digits)
  digits
    .each_with_index
    .max_by { |d, i| d }
end

def part1
  data = load_input
  joltages = data.map { |line| largest_joltage(line) }
  joltages.sum
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
