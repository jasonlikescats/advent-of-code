require "csv"

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
            send chemical
            @ore_count
        end

        private

        def reset
            @ore_count = 0
            @stockpile = Hash.new(0)
        end

        def define_reaction_methods reactions
            reactions.each do |resultant, components|
                FunctionalReactor.define_method(resultant.name) do
                    if @stockpile[resultant.name] > 0
                        @stockpile[resultant.name] -= 1
                    else
                        components.each do |component|
                            component.count.times { send component.name }
                        end

                        @stockpile[resultant.name] += resultant.count - 1
                    end
                end
            end
        end

        def ORE
            @ore_count += 1
        end
    end

    def self.part1(reactions)
        reactor = FunctionalReactor.new reactions
        reactor.ore_count "FUEL"
    end

    def self.part2(reactions)
        "TODO"
    end
end

reactions = Day14.reactions_from_input(File.readlines("input.txt"))
puts "Part 1: " + Day14.part1(reactions).to_s
puts "Part 2: " + Day14.part2(reactions).to_s
