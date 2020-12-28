class Grid4D(T)
  include Enumerable(T)

  struct Coords
    property x : Int32, y : Int32, z : Int32, w : Int32

    def initialize(@x, @y, @z, @w)
    end
  end

  # ordered w -> z -> y -> x
  private getter data : Array(Array(Array(Array(T))))

  def initialize(@data)
  end

  # enumerates each datum in w -> z -> y -> x order.
  # e.g. w, x,y,z = [0, 0, 0, 0]
  #               = [0, 1, 0, 0]
  #               = [0, 0, 1, 0]
  #               = [0, 1, 1, 0]
  #               = [0, 0, 0, 1]
  #               etc.
  def each
    each_with_index { |d, _| yield d }
  end

  def each_with_index
    data.each_with_index do |space, w_idx|
      space.each_with_index do |z_plane, z_idx|
        z_plane.each_with_index do |zy_vec, y_idx|
          zy_vec.each_with_index do |datum, x_idx|
            coords = Coords.new(x_idx, y_idx, z_idx, w_idx)
            yield(datum, coords)
          end
        end
      end
    end
  end

  def lookup(x, y, z, w)
    return nil if out_of_bounds?(x, y, z, w)

    data.dig(w, z, y, x)
  end

  def neighbors(coords)
    (coords.w-1..coords.w+1).flat_map do |i|
      (coords.z-1..coords.z+1).flat_map do |j|
        (coords.y-1..coords.y+1).flat_map do |k|
          (coords.x-1..coords.x+1).map do |l|
            if coords.w == i && coords.z == j && coords.y == k && coords.x == l
              nil
            else
              lookup(l, k, j, i)
            end
          end.compact
        end
      end
    end
  end

  def expand(&block : -> T)
    z_size = data.first.size + 2
    y_size = data.first.first.size + 2
    x_size = data.first.first.first.size + 2

    data.each_with_index { |_, w_index| expand_3D(w_index, &block) }

    data.push(create_w_space(x_size, y_size, z_size, block))
    data.unshift(create_w_space(x_size, y_size, z_size, block))
  end

  def expand_3D(w_index = 0, &block : -> T)
    y_size = data.first.first.size + 2
    x_size = data.first.first.first.size + 2

    w_space = data[w_index]
    w_space.each do |z_plane|
      z_plane.each do |zy_vec|
        zy_vec.push(block.call)
        zy_vec.unshift(block.call)
      end

      z_plane.push(create_zy_vec(x_size, block))
      z_plane.unshift(create_zy_vec(x_size, block))
    end

    w_space.push(create_z_plane(x_size, y_size, block))
    w_space.unshift(create_z_plane(x_size, y_size, block))
  end

  private def out_of_bounds?(x, y, z, w)
    w < 0 || w >= data.size ||
    z < 0 || z >= data[w].size ||
    y < 0 || y >= data[w][z].size ||
    x < 0 || x >= data[w][z][y].size
  end

  private def create_w_space(x_size, y_size, z_size, block)
    space = Array(Array(Array(T))).new
    z_size.times { space << create_z_plane(x_size, y_size, block) }
    space
  end

  private def create_z_plane(x_size, y_size, block)
    plane = Array(Array(T)).new
    y_size.times { plane << create_zy_vec(x_size, block) }
    plane
  end

  private def create_zy_vec(x_size, block)
    v = Array(T).new
    x_size.times { v << block.call }
    v
  end
end
