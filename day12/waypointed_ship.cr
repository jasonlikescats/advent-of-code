class Moveable
  # positions relative to start
  getter east_west_position : Int32, north_south_position : Int32

  def initialize(@east_west_position, @north_south_position)
  end

  def move(direction, magnitude)
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

  def move_relative(other, multiplier)
    ew_delta = other.east_west_position - east_west_position
    ns_delta = other.north_south_position - north_south_position
    ew_magnitude = ew_delta * multiplier
    ns_magnitude = ns_delta * multiplier

    move('E', ew_magnitude)
    move('N', ns_magnitude)
    other.move('E', ew_magnitude)
    other.move('N', ns_magnitude)
  end

  def rotate(direction, magnitude, relative_to)
    turn_count = (magnitude / 90).to_i

    ew_delta = east_west_position - relative_to.east_west_position
    ns_delta = north_south_position - relative_to.north_south_position
    turn_count.times do
      temp = ew_delta
      if direction == 'R'
        ew_delta = ns_delta
        ns_delta = 0 - temp
      else
        ew_delta = 0 - ns_delta
        ns_delta = temp
      end
    end

    @east_west_position = ew_delta + relative_to.east_west_position
    @north_south_position = ns_delta + relative_to.north_south_position
  end
end

class WaypointedShip
  getter ship : Moveable, waypoint : Moveable

  def initialize(waypoint_east_west_position, waypoint_north_south_position)
    @ship = Moveable.new(0, 0)
    @waypoint = Moveable.new(waypoint_east_west_position, waypoint_north_south_position)
  end

  def east_west_position
    ship.east_west_position
  end

  def north_south_position
    ship.north_south_position
  end

  def apply_instruction(instruction)
    if ['N', 'S', 'E', 'W'].includes?(instruction.direction)
      waypoint.move(instruction.direction, instruction.magnitude)
    elsif ['L', 'R'].includes?(instruction.direction)
      waypoint.rotate(instruction.direction, instruction.magnitude, ship)
    elsif 'F' == instruction.direction
      ship.move_relative(waypoint, instruction.magnitude)
    else
      raise "Unknown instruction"
    end
  end
end
