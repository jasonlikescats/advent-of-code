require "file"

class Dial
  getter :position
  getter :zeros
  getter :crossed_zeros

  def initialize
    @position = 50
    @zeros = 0
    @crossed_zeros = 0
    @positions_count = 100
  end

  def turn_left(amount)
    if @position == 0
      @position = @positions_count
    end

    new_pos = @position - amount
    
    while new_pos < 0
      new_pos += @positions_count
      @crossed_zeros += 1
    end

    @position = new_pos

    if @position == 0
      @zeros += 1
      @crossed_zeros += 1
    end
  end

  def turn_right(amount)
    new_pos = @position + amount

    while new_pos >= @positions_count
      new_pos -= @positions_count
      @crossed_zeros += 1
    end

    @position = new_pos

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
  dial = Dial.new
  execute_combination(data, dial)

  dial.crossed_zeros
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
