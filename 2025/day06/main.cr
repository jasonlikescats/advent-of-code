require "file"

class Problem
  def initialize(operand : String, args : Array(Int64))
    @operand = operand
    @args = args
  end

  def solve : Int64
    if @operand == "*"
      @args.product
    elsif @operand == "+"
      @args.sum
    else
      raise "Invalid operand"
    end
  end
end

def load_input : Array(Problem)
  filename = "input"

  {% if flag?(:sample) %}
    filename = "sample_input"
  {% end %}
  
  lines = File
    .read_lines(filename)
    .map { |line| line.strip.split(/\s+/) }

  res = lines[-1].each_with_index
  res.map do |operand, i|
    args = lines[0...-1].map { |line| line[i].to_i64 }
    Problem.new(operand.strip, args)
  end.to_a
end

def part1
  problems = load_input
  problems.sum(&.solve)
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
