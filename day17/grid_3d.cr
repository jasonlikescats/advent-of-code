class Grid3D(T)
  include Enumerable(T)

  struct Coords
    property x : Int32, y : Int32, z : Int32

    def initialize(@x, @y, @z)
    end
  end

  # ordered z -> y -> x
  private getter data : Array(Array(Array(T)))

  def initialize(@data)
  end

  # enumerates each datum in z -> y -> x order.
  # e.g. x,y,z = [0, 0, 0]
  #            = [1, 0, 0]
  #            = [0, 1, 0]
  #            = [1, 1, 0]
  #            = [0, 0, 1]
  #            etc.
  def each
    each_with_index { |d, _| yield d }
  end

  def each_with_index
    data.each_with_index do |z_plane, z_idx|
      z_plane.each_with_index do |zy_vec, y_idx|
        zy_vec.each_with_index do |datum, x_idx|
          coords = Coords.new(x_idx, y_idx, z_idx)
          yield(datum, coords)
        end
      end
    end
  end

  # (for debug use)
  def serialize
    str = ""
    data.each_with_index do |z_plane, z_idx|
      str += "z=#{z_idx}\n"
      z_plane.each do |zy_vec|
        zy_vec.each do |datum|
          str += datum.to_s
        end
        str += '\n'
      end
      str += "\n\n"
    end
    str
  end

  def lookup(x, y, z)
    return nil if out_of_bounds?(x, y, z)

    data.dig(z, y, x)
  end

  def neighbors(coords)
    (coords.z-1..coords.z+1).flat_map do |i|
      (coords.y-1..coords.y+1).flat_map do |j|
        (coords.x-1..coords.x+1).map do |k|
          if coords.z == i && coords.y == j && coords.x == k
            nil
          else
            lookup(k, j, i)
          end
        end.compact
      end
    end
  end

  def expand(&block : -> T)
    y_size = data.first.size + 2
    x_size = data.first.first.size + 2

    data.each do |z_plane|
      z_plane.each do |zy_vec|
        zy_vec.push(block.call)
        zy_vec.unshift(block.call)
      end

      z_plane.push(create_zy_vec(x_size, block))
      z_plane.unshift(create_zy_vec(x_size, block))
    end

    data.push(create_z_plane(x_size, y_size, block))
    data.unshift(create_z_plane(x_size, y_size, block))
  end

  private def out_of_bounds?(x, y, z)
    z < 0 || z >= data.size ||
    y < 0 || y >= data[z].size ||
    x < 0 || x >= data[z][y].size
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
