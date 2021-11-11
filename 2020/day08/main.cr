require "file"
require "./bootloader"

def load_input
  File.read_lines("input")
end

def run_to_loop_or_termination(bootloader)
  executed_instructions = [] of Int32
  while true
    return :terminated if bootloader.terminated?

    next_instruction = bootloader.state.program_counter
    return :loop if executed_instructions.includes?(next_instruction)

    executed_instructions << next_instruction
    bootloader.step
  end
end

def replace_instruction(index, input)
  instruction = input[index]
  case instruction[0..2]
  when "acc"
    nil
  when "jmp"
    input[index] = instruction.gsub("jmp", "nop")
    input
  when "nop"
    input[index] = instruction.gsub("nop", "jmp")
    input
  end
end

def part1
  bootloader = Bootloader.new(load_input)
  run_to_loop_or_termination(bootloader)

  bootloader.state.accumulator
end

def part2
  input = load_input
  
  input.each_with_index do |_, index|
    modified_input = replace_instruction(index, input.dup)
    next unless modified_input

    bootloader = Bootloader.new(modified_input)
    result = run_to_loop_or_termination(bootloader)

    return bootloader.state.accumulator if result == :terminated
  end
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
