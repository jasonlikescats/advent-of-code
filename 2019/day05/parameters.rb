module ShipComputer
    class Parameters
        def self.parse_modes(opcode, input_parameter_count)
            explicit_modes = opcode
                .to_s[0..-3]
                .reverse!
                .each_char
                .map(&:to_i)

            # pad by defaulting to '0' (implicit modes)
            modes = Array.new(input_parameter_count) {
                |i| i < explicit_modes.length ?
                    explicit_modes[i] :
                    0
            }

            modes
        end

        def self.create_input_parameter(mode, memory, parameter_address)
            parameter_value = memory[parameter_address]

            case mode
            when 0
                PositionModeParameter.new(memory, parameter_value)
            when 1
                ImmediateModeParameter.new(parameter_value)
            end
        end

        def self.create_output_parameter(memory, parameter_address)
            parameter_value = memory[parameter_address]
            PositionModeParameter.new(memory, parameter_value)
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
end
