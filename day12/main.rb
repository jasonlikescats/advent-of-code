require "csv"

module Day12
    class Coordinate
        def initialize(x, y, z)
            @x, @y, @z = x, y, z
        end

        attr_accessor :x
        attr_accessor :y
        attr_accessor :z

        def pretty_print
            "<x=#{format_num @x}, y=#{format_num @y}, z=#{format_num @z}>"
        end

        def duplicate
            Coordinate.new(@x.dup, @y.dup, @z.dup)
        end

        private

        def format_num(num)
            num.to_s.rjust(3, ' ')
        end
    end

    class Body
        def initialize(position, velocity)
            @initial_position, @initial_velocity = position.duplicate, velocity.duplicate
            @position, @velocity = position, velocity
        end

        attr_reader :position
        attr_reader :velocity

        def apply_gravity(acting_body)
            apply_axis_gravity(:x, acting_body)
            apply_axis_gravity(:y, acting_body)
            apply_axis_gravity(:z, acting_body)
        end

        def apply_velocity
            @position.x += @velocity.x
            @position.y += @velocity.y
            @position.z += @velocity.z
        end

        def energy
            potential = @position.x.abs + @position.y.abs + @position.z.abs
            kinetic = @velocity.x.abs + @velocity.y.abs + @velocity.z.abs
            potential * kinetic
        end

        def in_initial_state?(dimension)
            pos_eq = @initial_position.send(dimension) == @position.send(dimension)
            vel_eq = @initial_velocity.send(dimension) == @velocity.send(dimension)

            pos_eq && vel_eq
        end

        private

        def apply_axis_gravity(axis, acting_body)
            axis_sym = axis.to_sym
            pos_self = @position.send(axis_sym)
            pos_other = acting_body.position.send(axis_sym)

            v_self = @velocity.send(axis_sym)
            v_other = acting_body.velocity.send(axis_sym)

            if pos_self < pos_other
                v_self += 1
                v_other -= 1
            elsif pos_self > pos_other
                v_self -= 1
                v_other += 1
            end

            axis_set_sym = "#{axis}=".to_sym
            @velocity.send(axis_set_sym, v_self)
            acting_body.velocity.send(axis_set_sym, v_other)
        end
    end

    def self.log_stats(step_num, bodies)
        puts "After #{step_num} steps:"
        for body in bodies do
            puts "pos=#{body.position.pretty_print}, vel=#{body.velocity.pretty_print}"
        end
        puts "\n"
    end

    def self.step(bodies)
        bodies.each_with_index do |body, idx|
            for other_idx in (idx+1..bodies.length-1) do
                body.apply_gravity(bodies[other_idx])
            end
        end

        bodies.each { |body| body.apply_velocity }
    end

    def self.bodies_from_input(input_lines)
        input_lines.map do |line|
            parsed = /<x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>/.match(line)
            position = Coordinate.new(parsed[:x].to_i, parsed[:y].to_i, parsed[:z].to_i)
            velocity = Coordinate.new(0, 0, 0)
            Body.new(position, velocity)
        end
    end

    def self.part1(bodies)
        (1..1000).each { |i| step(bodies) }

        bodies.map {|b| b.energy}.reduce(:+)
    end

    def self.repetition_freq_for_dimension(bodies, dimension)
        first_init_state = 0
        count = 0
        loop do
            step(bodies)
            count += 1
            
            if bodies.all? {|b| b.in_initial_state?(dimension)}
                # I can't brain out why right now, but the first time you hit this
                # the intial state again is outside of the normal repeat pattern
                # so you need to wait until the second occurence (which will be on
                # the regular schedule) and subtract the difference from the first
                if first_init_state == 0
                    first_init_state = count
                else
                    return count - first_init_state
                end
            end
        end

        count
    end

    def self.part2(bodies)
        x_rep = repetition_freq_for_dimension(bodies, :x)
        y_rep = repetition_freq_for_dimension(bodies, :y)
        z_rep = repetition_freq_for_dimension(bodies, :z)

        [x_rep, y_rep, z_rep].reduce(1, :lcm)
    end
end

bodies1 = Day12.bodies_from_input(File.readlines("input.txt"))
puts "Part 1: " + Day12.part1(bodies1).to_s

bodies2 = Day12.bodies_from_input(File.readlines("input.txt"))
puts "Part 2: " + Day12.part2(bodies2).to_s
