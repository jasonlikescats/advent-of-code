require "file"

def load_input
  filename = "input"

  {% if flag?(:sample) %}
    filename = "sample_input"
  {% end %}
  
  File.read_lines(filename).map(&.chars)
end

class Grid
  @@empty = '.'
  @@full = '@'
  @@marked = 'x'

  def initialize(grid : Array(Array(Char)))
    @grid = grid
  end

  def self.unblocked_count(marked_grid)
    marked_grid.sum { |row| row.count { |cell| cell == @@marked }}
  end

  def mark_unblocked(max_neighbors = 4)
    processed_grid = @grid.clone

    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        is_paper = cell == @@full
        if is_paper && full_neighbor_count(y, x) < max_neighbors
          processed_grid[y][x] = @@marked
        end
      end
    end

    processed_grid
  end

  def unblock(marked_grid)
    @grid = marked_grid
  end

  private def full_neighbor_count(row, col)
    local_grid = local_grid(row, col)
    full_count = local_grid.sum do |r|
      r.count { |cell| cell == @@full }
    end

    full_count -= 1 if local_grid[1][1] == @@full

    {% if flag?(:viz) %}
      puts "PROCESSING #{row}, #{col}"
      local_grid.each { |row| puts row.join }
      puts "COUNT: #{full_count}"
      puts ""
    {% end %}

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
  Grid.unblocked_count(grid.mark_unblocked)
end

def part2
  grid = Grid.new(load_input)
  
  last_count = 0
  loop do
    marked_grid = grid.mark_unblocked
    count = Grid.unblocked_count(marked_grid)
    
    break if count == last_count
    
    grid.unblock(marked_grid)
    last_count = count
  end

  last_count
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
