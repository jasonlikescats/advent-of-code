require "file"

def load_input
  File.read_lines("input").map(&.to_i)
end

def load_chained_joltages
  adapter_joltages = load_input
  outlet_joltage = 0
  device_joltage = adapter_joltages.max + 3

  joltages = adapter_joltages.concat([outlet_joltage, device_joltage])
  joltages.sort
end

def joltage_steps(chained_joltages)
  chained_joltages.skip(1).map_with_index do |joltage, idx|
    prev_idx = idx # Don't subtract one since we've `skip`ed
    prev_joltage = chained_joltages[prev_idx]
    joltage - prev_joltage
  end
end

def part1
  chained_joltages = load_chained_joltages
  steps = joltage_steps(chained_joltages)

  steps_1 = steps.count(1)
  steps_3 = steps.count(3)

  steps_1 * steps_3
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
