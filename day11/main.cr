require "file"

class SeatGrid
  class Seat
    EMPTY = 'L'
    OCCUPIED = '#'
    FLOOR = '.'

    property state : Char

    def initialize(@state)
    end

    def floor?
      state == FLOOR
    end

    def next_state(adjacent_states, occupancy_threshold)
      if state == EMPTY && !adjacent_states.any? { |s| s == OCCUPIED }
        OCCUPIED
      elsif state == OCCUPIED && adjacent_states.count(OCCUPIED) >= occupancy_threshold
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

  def step_adjacency_simulation
    step_simulation(->adjacent_seat_states(Int32, Int32), 4)
  end

  def step_visibility_simulation
    step_simulation(->visible_seat_states(Int32, Int32), 5)
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

  private def step_simulation(seat_selector, occupancy_threshold)
    next_states = Hash(Seat, Char).new

    seats.each_with_index do |row, row_idx|
      row.each_with_index do |seat, col_idx|
        considered_seats = seat_selector.call(row_idx, col_idx)
        next_states[seat] = seat.next_state(considered_seats, occupancy_threshold)
      end
    end

    next_states.each { |seat, state| seat.state = state }
  end

  private def adjacent_seat_states(row, col)
    adjacent_indices = [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]

    adjacent_indices
      .reject { |r, c| out_of_bounds(r, c) }
      .map { |r, c| seats[r][c].state }
  end

  private def visible_seat_states(row, col)
    directions = [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, -1},
      {1, 0},
      {1, 1}
    ]

    directions
      .map { |dir| next_seat_visible_in_direction(row, col, dir[0], dir[1]) }
      .reject(&.nil?)
      .map(&.not_nil!)
      .map(&.state)
  end

  private def next_seat_visible_in_direction(start_row, start_col, row_dir, col_dir)
    row = start_row + row_dir
    col = start_col + col_dir
    return nil if out_of_bounds(row, col)

    seat = seats[row][col]
    return next_seat_visible_in_direction(row, col, row_dir, col_dir) if seat.floor?

    seat
  end

  private def out_of_bounds(row, col)
    row < 0 || row >= seats.size || col < 0 || col >= seats.first.size
  end
end

def load_input
  SeatGrid.new(File.read("input"))
end

def count_stabilized_occupied(grid, simulation_method)
  loop do
    last_state = grid.serialize
    simulation_method.call
    break if last_state == grid.serialize
  end

  grid.seats.flatten.map(&.state).count(SeatGrid::Seat::OCCUPIED)
end

def part1
  grid = load_input

  count_stabilized_occupied(grid, ->grid.step_adjacency_simulation)
end

def part2
  grid = load_input
  
  count_stabilized_occupied(grid, ->grid.step_visibility_simulation)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
