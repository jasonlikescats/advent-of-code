require "file"

def load_input
  File
    .read_lines("input")[0]
    .split(',')
    .map { |range| range.split('-').map(&.to_i64) }
    .map { |arr| Tuple(Int64, Int64).from(arr) }
end

def is_repeating?(num)
  str_num = num.to_s
  return false unless str_num.size.even?

  half = str_num.size.tdiv(2)
  front = str_num[0...half]
  back = str_num[half..-1]

  front == back
end

def part1
  ranges = load_input

  repeats = ranges.flat_map do |r1, r2| 
    # iterate integers from r1 to r2
    (r1..r2)
      .to_a
      .map { |i| is_repeating?(i) ? i : nil }
      .compact
  end

  repeats.sum
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
