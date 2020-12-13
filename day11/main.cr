require "file"

class SeatGrid
  class Seat
    EMPTY = 'L'
    OCCUPIED = '#'
    FLOOR = '.'

    property state : Char

    def initialize(@state)
    end

    def next_state(adjacent_states)
      if state == EMPTY && !adjacent_states.any? { |s| s == OCCUPIED }
        OCCUPIED
      elsif state == OCCUPIED && adjacent_states.count(OCCUPIED) >= 4
        EMPTY
      else
        state
      end
    end
  end

  getter seats : Array(Array(Seat))

  def initialize(seat_map)
    @seats = parse_seats(seat_map)
  end

  def step_simulation
    next_states = Hash(Seat, Char).new
    seats.each_with_index do |row, row_idx|
      row.each_with_index do |seat, col_idx|
        next_states[seat] = seat.next_state(adjacent_states(row_idx, col_idx))
      end
    end

    next_states.each { |seat, state| seat.state = state }
  end

  def serialize
    data = ""
    seats.each do |row|
      row.each do |seat|
        data += seat.state
      end
      data += '\n'
    end
    data
  end

  private def parse_seats(seat_map)
    seat_map
      .split('\n')
      .map(&->parse_seat_row(String))
  end

  private def parse_seat_row(row_map)
    row_map.chars.map { |seat| Seat.new(seat) }
  end

  private def adjacent_states(row_idx, col_idx)
    adjacent_indices = [
      {row_idx - 1, col_idx - 1},
      {row_idx - 1, col_idx},
      {row_idx - 1, col_idx + 1},
      {row_idx, col_idx - 1},
      {row_idx, col_idx + 1},
      {row_idx + 1, col_idx - 1},
      {row_idx + 1, col_idx},
      {row_idx + 1, col_idx + 1}
    ]

    adjacent_indices
      .reject { |r, c| r < 0 || r >= seats.size || c < 0 || c >= seats.first.size }
      .map { |r, c| seats[r][c].state }
  end
end

def load_input
  SeatGrid.new(File.read("input"))
end

def part1
  grid = load_input

  loop do
    last_state = grid.serialize
    grid.step_simulation
    break if last_state == grid.serialize
  end

  grid.seats.flatten.map(&.state).count(SeatGrid::Seat::OCCUPIED)
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
