class NaiveShip
  # positions relative to start
  getter east_west_position : Int32, north_south_position : Int32
  getter direction

  def initialize
    @east_west_position = 0
    @north_south_position = 0
    @direction = 'E'
  end

  def apply_instruction(instruction)
    if ['L', 'R'].includes?(instruction.direction)
      apply_turn(instruction)
    else
      apply_move(instruction)
    end
  end

  private def apply_turn(instruction)
    turn_count = instruction.magnitude / 90

    sequence = ['N', 'E', 'S', 'W']
    sequence.reverse! if instruction.direction == 'L'

    start = sequence.index(direction).not_nil!
    resultant = (start + turn_count).to_i % sequence.size
    @direction = sequence[resultant]
  end

  private def apply_move(instruction)
    if instruction.direction == 'F'
      move_in_direction(direction, instruction.magnitude)
    else
      move_in_direction(instruction.direction, instruction.magnitude)
    end
  end

  private def move_in_direction(direction, magnitude)
    case direction
    when 'N'
      @north_south_position += magnitude
    when 'S'
      @north_south_position -= magnitude
    when 'E'
      @east_west_position += magnitude
    when 'W'
      @east_west_position -= magnitude
    end
  end
end
