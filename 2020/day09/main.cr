require "file"

class XmasDecoder
  PREAMBLE_SIZE = 25

  private getter numbers : Array(Int64)

  def initialize(@numbers)
  end

  def encryption_weakness
    range = find_contiguous_summing(find_first_invalid).not_nil!

    range.min + range.max
  end

  def find_first_invalid
    numbers
      .each_with_index
      .skip(PREAMBLE_SIZE)
      .find { |n, index| !valid?(preamble_for_index(index), n) }
      .not_nil!
      .at(0)
  end

  def find_contiguous_summing(target)
    numbers.each_with_index do |start_n, start_idx|
      range_size = (2..).find do |size|
        end_idx = start_idx + size
        sum = numbers[start_idx..end_idx].sum
        break if sum > target

        sum == target
      end

      return numbers[start_idx..start_idx+range_size] if range_size
    end
  end

  private def preamble_for_index(index)
    numbers[index-PREAMBLE_SIZE..index-1]
  end

  private def valid?(preamble, candidate)
    combinations = preamble.combinations(2)
    combinations.any? { |preamble_pair| preamble_pair.sum == candidate }
  end
end

def load_input
  File.read_lines("input").map(&.to_i64)
end

def part1
  XmasDecoder.new(load_input).find_first_invalid
end

def part2
  XmasDecoder.new(load_input).encryption_weakness
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
