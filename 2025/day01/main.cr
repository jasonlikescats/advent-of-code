require "file"

class Dial
  getter :position
  getter :zeros

  def initialize
    @position = 50
    @zeros = 0
    @positions_count = 100
  end

  def turn_left(amount)
    right_equiv = @positions_count - (amount % @positions_count)
    turn_right(right_equiv)
  end

  def turn_right(amount)
    @position += amount
    @position %= @positions_count

    @zeros += 1 if @position == 0
  end
end

def load_input
  File.read_lines("input")
end

def execute_combination(data, dial)
  data.each do |turn|
    amount = turn[1..-1].to_i

    case turn[0]
    when 'L'
      dial.turn_left(amount)
    when 'R'
      dial.turn_right(amount)
    end

    puts(dial.position)
  end
end

def part1
  data = load_input
  dial = Dial.new
  execute_combination(data, dial)

  dial.zeros
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
