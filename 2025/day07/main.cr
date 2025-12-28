require "file"

class TachyonManifold
  getter height : Int32
  getter diagram : Array(String)
  getter split_count : Int32

  def initialize(diagram_lines, beam_indices = [] of Array(Int32))
    @diagram = diagram_lines
    @beam_indices = beam_indices
    @height = @diagram.size
    @width = @diagram.first.size
    @split_count = 0
    @step = 0
  end

  def simulate
    while step_simulation
      {% if flag?(:viz) %}
        visualize_state
      {% end %}
    end
  end

  protected def step_simulation
    case @step
    when 0
      process_start_row
    when @height - 1
      process_end_row
    else
      process_inner_row
    end
  end

  protected def process_start_row
    start_idx = @diagram[@step].index('S')
    raise "Invalid start row" if start_idx.nil?

    @beam_indices << [start_idx]
    @step += 1
    true # continue execution
  end

  protected def process_inner_row
    last_row_beams = @beam_indices[@step - 1]
    beam_indices = [] of Int32
    
    last_row_beams.each do |beam_idx|
      if @diagram[@step][beam_idx] == '^'
        # split the beam
        @split_count += 1

        left_idx = beam_idx - 1
        right_idx = beam_idx + 1
        beam_indices << left_idx if left_idx > 0
        beam_indices << right_idx if right_idx < @width
      else
        # beam continues through
        beam_indices << beam_idx
      end
    end

    @beam_indices << beam_indices.uniq
    @step += 1
    true # continue execution
  end

  protected def process_end_row
    false # stop execution
  end

  private def visualize_state
    puts "Step #{@step} (splits = #{@split_count}):"

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

class QuantumTachyonManifold < TachyonManifold
  protected def process_start_row
    # If we have an incoming beam, it's not a true start row
    # but a split universe manifold we're starting
    incoming_beam = @beam_indices.first?.try(&.first)
    if incoming_beam.nil?
      start_idx = @diagram[@step].index('S')
      raise "Invalid start row" if start_idx.nil?

      @beam_indices << [start_idx]
    else
      # retain incoming beam
      @beam_indices << [incoming_beam]
    end

    @step += 1
    true # continue execution
  end

  protected def process_inner_row
    beam_idx = @beam_indices[@step - 1][0] # quantum should have only a single beam

    if @diagram[@step][beam_idx] == '^'
      # split the beam by forking to two new parallel universe splitters
      left_idx = beam_idx - 1
      right_idx = beam_idx + 1
      raise "out of bounds (left)" if left_idx < 0
      raise "out of bounds (right)" if right_idx >= @width
      
      left_manifold = QuantumTachyonManifold.new(@diagram[@step..], [[left_idx]])
      right_manifold = QuantumTachyonManifold.new(@diagram[@step..], [[right_idx]])

      left_manifold.simulate
      right_manifold.simulate

      # count the resultant splits from each sub-universe
      @split_count += left_manifold.split_count + right_manifold.split_count
      
      # stop execution; we've simulated the rest via the child manifolds
      # split off above
      false
    else
      # beam continues through; continue execution
      @beam_indices << [beam_idx]
      @step += 1
      true
    end
  end

  protected def process_end_row
    # now that this path has resolved, we can count it as a distinct
    # universe split path
    @split_count += 1
    false # stop execution
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
  manifold = QuantumTachyonManifold.new(load_input)
  manifold.simulate
  manifold.split_count
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
