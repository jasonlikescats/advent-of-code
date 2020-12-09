require "file"

PREAMBLE_SIZE = 25

class XmasDecoder
  def self.valid?(preamble, candidate)
    combinations = preamble.combinations(2)
    combinations.any? { |preamble_pair| preamble_pair.sum == candidate }
  end
end

def load_input
  File.read_lines("input").map(&.to_i64)
end

def part1
  numbers = load_input

  invalid_result = numbers
    .each_with_index
    .skip(PREAMBLE_SIZE)
    .find do |n, index|
      preamble = numbers[index-PREAMBLE_SIZE..index-1]
      !XmasDecoder.valid?(preamble, n)
    end

  invalid_result.try(&.at(0))
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
