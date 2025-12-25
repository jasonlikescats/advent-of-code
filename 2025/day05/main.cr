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
  ranges, _ids = load_input
  sorted_ranges = ranges.sort_by!(&.begin)

  exclusive_ranges = [sorted_ranges[0]]
  sorted_ranges.each do |range|
    last_range = exclusive_ranges[-1]
    
    if last_range.includes?(range.begin)
      if !last_range.includes?(range.end)
        # adjust end of last range to include this one
        exclusive_ranges[-1] = (last_range.begin..range.end)
      end
    else
      # range is exclusive of known ranges
      exclusive_ranges << range
    end
  end

  exclusive_ranges.sum { |r| r.end - r.begin + 1 }
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
