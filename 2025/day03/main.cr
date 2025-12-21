require "file"

def load_input
  File
    .read_lines("input")
    .map { |line| line.chars.map(&.to_i) }
end

def largest_joltage(bank, battery_count)
  start_idx = 0
  result = 0_u64

  battery_count.times do |i|
    max_idx = -battery_count + i + 1

    slice = max_idx == 0 ? bank[start_idx..] : bank[start_idx...max_idx]
    max, idx = largest_digit_with_index_from(slice)

    start_idx = start_idx + idx + 1
    result = result * 10 + max
  end

  result
end

def largest_digit_with_index_from(digits)
  digits
    .each_with_index
    .max_by { |d, i| d }
end

def part1
  data = load_input
  joltages = data.map { |line| largest_joltage(line, 2) }
  joltages.sum
end

def part2
  data = load_input
  joltages = data.map { |line| largest_joltage(line, 12) }
  joltages.sum
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
