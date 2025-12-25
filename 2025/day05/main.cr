require "file"

def load_input
    filename = "input"

  {% if flag?(:sample) %}
    filename = "sample_input"
  {% end %}
  
  lines = File.read_lines(filename)

  # process until empty line
  ranges = lines
    .take_while { |line| !line.empty? }
    .map do |line|
      parts = line.split('-')
      (parts[0].to_i64..parts[1].to_i64)
    end

  ids = lines
    .reverse
    .take_while { |line| !line.empty? }
    .reverse
    .map(&.to_i64)

  {ranges, ids}
end

def part1
  ranges, ids = load_input

  ids.count do |id|
    ranges.any? { |r| r.includes?(id) }
  end
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
