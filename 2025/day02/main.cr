require "file"

def load_input
  File
    .read_lines("input")[0]
    .split(',')
    .map { |range| range.split('-').map(&.to_i64) }
    .map { |arr| Tuple(Int64, Int64).from(arr) }
end

def repeats_n?(str, n)
  return false unless str.size % n == 0

  part_size = str.size.tdiv(n)
  ptrs = (0...n).map { |i| i * part_size }
  parts = ptrs.map { |ptr| str[ptr...(ptr + part_size)] }

  parts.all? { |p| p == parts[0] }
end

def is_repeating?(num)
  str_num = num.to_s
  (2..str_num.size).any? { |n| repeats_n?(str_num, n) }
end

def sum_repeating(ranges)
  repeats = ranges.flat_map do |r1, r2| 
    (r1..r2)
      .to_a
      .map { |i| yield(i) ? i : nil }
      .compact
  end

  repeats.sum
end

def part1
  ranges = load_input
  sum_repeating(ranges) { |i| repeats_n?(i.to_s, 2) }
end

def part2
  ranges = load_input
  sum_repeating(ranges) { |i| is_repeating?(i) }
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
