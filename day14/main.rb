module Day14
    class Chemical
        def initialize(name, count)
            @name, @count = name, count
        end

        attr_reader :name
        attr_reader :count
    end

    def self.reactions_from_input(lines)
        lines
            .map { |line| line.scan /[ ]*([\d]*) ([\w]+)/ }
            .map { |line_matches|
                chemicals = line_matches.map { |match| Chemical.new(match[1].to_sym, match[0].to_i) }
                [ chemicals[-1], chemicals[ 0..-2 ] ]
            }
            .to_h
    end

    class FunctionalReactor
        def initialize reactions
            define_reaction_methods reactions
        end

        def ore_count chemical
            reset
            send chemical, 1

            @ore_count
        end

        def fuel_count ore_available, ore_per_fuel
            reset
            count = 0
            multipliers = [100000, 1000, 100, 10, 1]

            loop do
                remaining = ore_available - @ore_count
                batch_size = get_batch_size remaining, ore_per_fuel

                send "FUEL", batch_size

                return count if @ore_count > ore_available
                count += batch_size
            end
        end

        private

        def get_batch_size remaining_ore, ore_per_fuel
            rem_digit_count = remaining_ore.to_s.length
            fuel_ore_digit_count = ore_per_fuel.to_s.length
            fudge = 2
            [10 ** (rem_digit_count - fuel_ore_digit_count - fudge), 1].max
        end

        def reset
            @ore_count = 0
            @stockpile = Hash.new(0)
        end

        def define_reaction_methods reactions
            reactions.each do |resultant, components|
                FunctionalReactor.define_method(resultant.name) do |batch_size=1|
                    if @stockpile[resultant.name] >= batch_size
                        @stockpile[resultant.name] -= batch_size
                    else
                        components.each do |component|
                            component.count.times { send component.name, batch_size }
                        end

                        @stockpile[resultant.name] += (resultant.count - 1) * batch_size
                    end
                end
            end
        end

        def ORE(batch_size = 1)
            @ore_count += batch_size
        end
    end

    def self.part1(reactor)
        reactor.ore_count "FUEL"
    end

    def self.part2(reactor, ore_per_fuel)
        reactor.fuel_count 1000000000000, ore_per_fuel
    end
end

reactions = Day14.reactions_from_input(File.readlines("input.txt"))
reactor = Day14::FunctionalReactor.new reactions

ore_per_fuel = Day14.part1(reactor)
puts "Part 1: " + ore_per_fuel.to_s
puts "Part 2: " + Day14.part2(reactor, ore_per_fuel).to_s
