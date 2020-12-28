require "./grid_3d"

class CubeGrid
  class Cube
    INACTIVE = '.'
    ACTIVE = '#'

    property state : Char

    def initialize(@state)
    end

    def to_s
      state.to_s
    end

    def active?
      state == ACTIVE
    end

    def inactive?
      state == INACTIVE
    end

    def next_state(neighboring_cubes)
      adjacent_active = neighboring_cubes.map(&.state).count(ACTIVE)

      if active? && (adjacent_active == 2 || adjacent_active == 3)
        ACTIVE
      elsif inactive? && adjacent_active == 3
        ACTIVE
      else
        INACTIVE
      end
    end
  end

  getter cubes : Grid3D(Cube)

  def initialize(z_slice)
    slice_cubes = parse_cubes(z_slice)
    @cubes = Grid3D(Cube).new([slice_cubes])
  end

  def serialize
    cubes.serialize
  end

  def step_simulation
    next_states = Hash(Cube, Char).new

    cubes.expand { Cube.new(Cube::INACTIVE) }

    cubes.each_with_index do |cube, coords|
      neighboring_cubes = cubes.neighbors(coords)
      next_states[cube] = cube.next_state(neighboring_cubes)
    end

    next_states.each { |cube, state| cube.state = state }
  end

  def active_count
    cubes.count { |cube| cube.active? }
  end

  private def parse_cubes(z_slice)
    z_slice
      .split('\n')
      .map(&->parse_row(String))
  end

  private def parse_row(zy_vec)
    zy_vec.chars.map(&->Cube.new(Char))
  end
end
