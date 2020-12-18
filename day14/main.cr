require "file"

class Mask
  getter zero_mask : Int64, one_mask : Int64

  def initialize(mask : String)
    @zero_mask = parse_mask(mask, 0)
    @one_mask = parse_mask(mask, 1)
  end

  def apply(num)
    num &= zero_mask
    num |= one_mask
  end

  private def parse_mask(mask : String, bit : Int32)
    default_bit = bit ^ 1
    mask.gsub('X', "#{default_bit}".chars[0]).to_i64(base: 2)
  end
end

class MaskedOperation
  getter address : Int32, unmasked_value : Int64, mask : Mask

  def initialize(@address, @unmasked_value, @mask)
  end

  def masked_value
    mask.apply(unmasked_value)
  end
end

def parse_masked_operations(lines)
  bitmask = lines[0].split(" = ")[1]
  mask = Mask.new(bitmask)

  pattern = /mem\[(\d+)\] = (\d+)/
  lines.skip(1).map do |op_line|
    matches = pattern.match(op_line).not_nil!
    MaskedOperation.new(matches[1].to_i, matches[2].to_i64, mask)
  end
end

def load_input
  masked_chunks = File.read("input").split("\nmask")
  masked_chunks
    .map { |chunk| chunk.split('\n') }
    .flat_map(&->parse_masked_operations(Array(String)))
end

def part1
  operations = load_input

  memory = Hash(Int32, Int64).new
  operations.each { |op| memory[op.address] = op.masked_value }
  
  memory.values.sum
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
