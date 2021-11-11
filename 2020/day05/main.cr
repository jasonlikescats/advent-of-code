require "file"

class BoardingPass
  getter row : Int32, column : Int32, seat : Int32

  def initialize(encoded_seat)
    @row = parse_row(encoded_seat[0..6])
    @column = parse_column(encoded_seat[7..9])
    @seat = calculate_seat
  end

  private def parse_row(row_data)
    binary_decode(row_data, 'F')
  end

  private def parse_column(column_data)
    binary_decode(column_data, 'L')
  end

  private def binary_decode(data, unset_char)
    result = 0
    data.chars.each do |c|
      bit = c == unset_char ? 0 : 1
      result <<= 1 # shift
      result |= bit # append
    end
    result
  end

  private def calculate_seat
    row * 8 + column
  end
end

def load_passes
  File.read_lines("input").map(&->BoardingPass.new(String))
end

def part1
  load_passes.max_by { |pass| pass.seat }.seat
end

def part2
  seats = load_passes.map(&.seat).sort
  offset = seats.first
  seat_after_mine_index = seats.bsearch_index do |seat, index|
    seat - offset != index
  end

  seats[seat_after_mine_index.not_nil!] - 1
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
