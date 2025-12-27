require "file"

class Problem
  def initialize(operand : Char, args : Array(Int64))
    @operand = operand
    @args = args
  end

  def solve : Int64
    if @operand == '*'
      @args.product
    elsif @operand == '+'
      @args.sum
    else
      raise "Invalid operand"
    end
  end
end

def load_input
  filename = "input"

  {% if flag?(:sample) %}
    filename = "sample_input"
  {% end %}
  
  File.read_lines(filename)
end

def parse_lines_row_based(lines) : Array(Problem)
  lines = lines.map { |line| line.strip.split(/\s+/) }

  operands = lines[-1].each_with_index
  operands.map do |operand, i|
    args = lines[0...-1].map { |line| line[i].to_i64 }
    Problem.new(operand.strip[0], args)
  end.to_a
end

def parse_lines_columnar(lines) : Array(Problem)
  operand_line = lines[-1]
  problem_start_indexes = operand_line
    .chars
    .each_with_index
    .select { |char, _| !char.whitespace? }
    .map { |char, idx| idx }
    .to_a
  
  problem_start_indexes << operand_line.size + 1

  problems = [] of Problem
  problem_start_indexes.each_cons_pair do |start_idx, end_idx|
    operand = lines[-1][start_idx]
    span = end_idx - start_idx - 1

    args = [] of Int64
    span.times do |i|
      chars = lines[0...-1].map { |line| line[start_idx + i] }
      args << chars.join.to_i64
    end

    problems << Problem.new(operand, args)
  end

  problems
end

def part1
  lines = load_input
  problems = parse_lines_row_based(lines)
  problems.sum(&.solve)
end

def part2
  lines = load_input
  problems = parse_lines_columnar(lines)
  problems.sum(&.solve)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
