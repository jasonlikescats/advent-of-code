require "file"
require "./bootloader"

def load_input
  File.read_lines("input")
end

def part1
  bootloader = Bootloader.new(load_input)

  executed_instructions = [] of Int32
  while true
    next_instruction = bootloader.state.program_counter
    break if executed_instructions.includes?(next_instruction)

    executed_instructions << next_instruction
    bootloader.step
  end

  bootloader.state.accumulator
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
