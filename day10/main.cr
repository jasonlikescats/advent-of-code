require "file"
require "./run_length_encoder"

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
  chained_joltages = load_chained_joltages
  steps = joltage_steps(chained_joltages)

  # Repeated single steps give us the opportunity to skip adapters
  # and introduce combinations. For example, with two single-step
  # adapters in a row, we have an opportunity to skip the middle one
  # which introduces a 2x multiplier on the number of valid combinations.
  #
  # As our max skip size is 3, we have the following mapping of single-
  # step repeats to combination multiplier:
  #  - 1 single-step (e.g. 0, 1) => 1 combination
  #  - 2 single-steps (e.g. 0, 1, 2) => 2 combinations
  #  - 3 single-steps (e.g. 0, 1, 2, 3) => 4 combinations
  #  - 4 single-steps (e.g. 0, 1, 2, 3, 4) => 7 combinations
  #  - 5 single_steps (e.g. 0, 1, 2, 3, 4, 5) => 13 combinations
  #  - etc.
  #
  # This pattern is almost 2^(n-1), but breaks down once we hit our limit
  # of 3 adapters that cannot be skipped. We need to then subtract
  # combinations that would require skipping 3 or more steps. Note that as
  # we add steps, the number of disallowed skips (i.e. the groupings of 3
  # or more contiguous single-steps) grows in a recurrence relation that
  # can be modelled as:
  #   m * (m + 1) / 2 where m = n - max_skips
  # Here, max_skips = 3, so this reduces to:
  #   (n - 3) * (n - 2) / 2
  #
  # (Note that this only works if there's no steps of 2, but that isn't
  # the case for my puzzle input or any of the sample input.)
  encoded = RunLengthEncoder.encode(steps)
  single_step_run_lengths = encoded
    .select { |enc| enc.value == 1 && enc.count > 1 }
    .map(&.count)

  combination_factors = single_step_run_lengths.map do |step_run|
    combinations = 2 ** (step_run - 1)
    disallowed_combinations = step_run <= 3 ? 0 : (step_run - 3) * (step_run - 2) / 2

    combinations - disallowed_combinations
  end

  combination_factors
    .map(&.to_i64)
    .product
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
