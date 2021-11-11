require "file"
require "./mask"
require "./masked_operation"

def parse_masked_operations(mask_type, lines)
  mask_value = lines[0].split(" = ")[1]
  mask = mask_type.new(mask_value)

  pattern = /mem\[(\d+)\] = (\d+)/
  lines.skip(1).map do |op_line|
    matches = pattern.match(op_line).not_nil!
    MaskedOperation.new(matches[1].to_i64, matches[2].to_i64, mask)
  end
end

def load_input(mask_type)
  masked_chunks = File.read("input").split("\nmask")
  masked_chunks
    .map { |chunk| chunk.split('\n') }
    .flat_map { |chunk_lines| parse_masked_operations(mask_type, chunk_lines) }
end

def part1
  operations = load_input(OverwritingMask)

  memory = Hash(Int64, Int64).new
  operations.each { |op| memory[op.address] = op.apply_mask(op.value)[0] }

  memory.values.sum
end

def part2
  operations = load_input(AddressMask)

  memory = Hash(Int64, Int64).new
  operations.each do |op|
    addresses = op.apply_mask(op.address)
    addresses.each { |addr| memory[addr] = op.value }
  end

  memory.values.sum
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
