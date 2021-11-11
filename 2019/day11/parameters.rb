module ShipComputer
    class Parameters
        def self.parse_modes(opcode, parameter_count)
            explicit_modes = opcode
                .to_s[0..-3]
                .reverse!
                .each_char
                .map(&:to_i)

            # pad by defaulting to '0' (implicit modes)
            modes = Array.new(parameter_count) {
                |i| i < explicit_modes.length ?
                    explicit_modes[i] :
                    0
            }

            modes
        end

        def self.create_parameter(mode, memory, relative_base, parameter_address)
            parameter_value = memory[parameter_address]

            case mode
            when 0
                PositionModeParameter.new(memory, parameter_value)
            when 1
                ImmediateModeParameter.new(parameter_value)
            when 2
                RelativeModeParameter.new(memory, relative_base, parameter_value)
            end
        end
    end

    class ImmediateModeParameter
        def initialize(value)
            @value = value
        end

        def value
            @value
        end
    end

    class PositionModeParameter
        def initialize(memory, address)
            @memory, @address = memory, address
        end

        def value
            @memory[@address]
        end

        def set_value(new_value)
            @memory[@address] = new_value
        end
    end

    class RelativeModeParameter
        def initialize(memory, relative_base, relative_address_offset)
            @memory, @relative_base, @relative_address_offset =
                memory, relative_base, relative_address_offset
        end

        def value
            @memory[address]
        end

        def set_value(new_value)
            @memory[address] = new_value
        end

        private

        def address
            @relative_base + @relative_address_offset
        end
    end
end
