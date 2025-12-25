require "file"

def load_input
  File.read_lines("input").map(&.chars)
end

class Grid
  @@empty = '.'
  @@full = '@'

  def initialize(grid : Array(Array(Char)))
    @grid = grid
  end

  def unblocked_count(max_neighbors = 4)
    count = 0
    processed_grid = @grid.clone

    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        is_paper = cell == @@full
        if is_paper && full_neighbor_count(y, x) < max_neighbors
          count += 1
          processed_grid[y][x] = 'x'
        end
      end
    end

    processed_grid.each { |row| puts row.join }

    count
  end

  private def full_neighbor_count(row, col)
    local_grid = local_grid(row, col)
    full_count = local_grid.sum do |r|
      r.count { |cell| cell == @@full }
    end

    full_count -= 1 if local_grid[1][1] == @@full

    puts "PROCESSING #{row}, #{col} - #{local_grid[1][1]}"
    local_grid.each { |row| puts row.join }
    puts "COUNT: #{full_count}"
    puts ""

    full_count
  end

  private def local_grid(row, col)
    [
      [safe_get(row-1, col-1), safe_get(row-1, col), safe_get(row-1, col+1)],
      [safe_get(row,   col-1), safe_get(row,   col), safe_get(row,   col+1)],
      [safe_get(row+1, col-1), safe_get(row+1, col), safe_get(row+1, col+1)]
    ]
  end

  private def safe_get(row, col, fallback = @@empty)
    return fallback if row < 0 || col < 0
    return fallback if row >= @grid.size
    r = @grid[row]
    return fallback if col >= r.size
    r[col]
  end
end

def part1
  grid = Grid.new(load_input)
  grid.unblocked_count
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
