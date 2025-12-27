require "file"

class TachyonManifold
  getter height : Int32
  getter diagram : Array(String)
  getter split_count : Int32

  def initialize(diagram_lines)
    @diagram = diagram_lines
    @height = @diagram.size
    @width = @diagram.first.size
    @split_count = 0
    @step = 0
    @beam_indices = [] of Array(Int32)
  end

  def simulate
    @height.times do
      step_simulation
      {% if flag?(:viz) %}
        visualize_state
      {% end %}
    end
  end

  private def step_simulation
    case @step
    when 0
      # manifold start
      start_idx = @diagram[@step].index('S')
      raise "Invalid first line" if start_idx.nil?

      @beam_indices << [start_idx]
      @step += 1
    else
      # inside row
      last_row_beams = @beam_indices[@step - 1]
      beam_indices = [] of Int32
      
      last_row_beams.each do |beam_idx|
        if @diagram[@step][beam_idx] == '^'
          # split the beam
          @split_count += 1

          left_idx = beam_idx - 1
          right_idx = beam_idx + 1
          beam_indices << left_idx if !left_idx.nil?
          beam_indices << right_idx if !right_idx.nil?
        else
          # beam continues through
          beam_indices << beam_idx
        end
      end

      @beam_indices << beam_indices.uniq
      @step += 1
    end

  end

  private def visualize_state
    puts "Step #{@step}:"

    @diagram.each_with_index do |line, line_idx|
      line.each_char.with_index do |char, col_idx|
        if line_idx < @step && @beam_indices[line_idx].includes?(col_idx)
          print '|'
        else
          print char
        end
      end

      puts ""
    end

    puts ""
  end
end

def load_input
  filename = "input"

  {% if flag?(:sample) %}
    filename = "sample_input"
  {% end %}
  
  File.read_lines(filename)
end

def part1
  manifold = TachyonManifold.new(load_input)
  manifold.simulate
  manifold.split_count
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
