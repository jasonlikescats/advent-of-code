module Day04
    class RunLengthEncoder
        class Entry
            def initialize(value)
                @value = value
                @count = 1
            end

            attr_reader :value
            attr_reader :count

            def add_to_count
                @count += 1
            end
        end

        def self.encode(arr)
            encoded = []
            for i in 0..arr.length-1
                cur_value = arr[i]
                last = encoded.last

                if last && last.value == cur_value
                    last.add_to_count
                else
                    encoded.push Entry.new(cur_value)
                end
            end
            encoded
        end
    end

    def self.has_repeating_values(arr)
        RunLengthEncoder
            .encode(arr)
            .any? { |x| x.count > 1 }
    end


    def self.has_an_exact_double_repeat(arr)
        RunLengthEncoder
            .encode(arr)
            .any? { |x| x.count == 2 }
    end

    def self.non_decreasing_values(arr)
        for i in 1..arr.length-1
            return false if arr[i - 1] > arr[i]
        end
        true
    end

    def self.count_matching_candidates(low, high, rules)
        matches = []
        for candidate in low..high
            if rules.all? { |rule| rule.call(candidate) }
                matches.push(candidate)
            end
        end

        matches.length
    end

    def self.part1(low, high)
        rules = [
            Proc.new { |n| has_repeating_values(n.to_s) },
            Proc.new { |n| non_decreasing_values(n.to_s) }
        ]

        count_matching_candidates(low, high, rules)
    end

    def self.part2(low, high)
        rules = [
            Proc.new { |n| non_decreasing_values(n.to_s) },
            Proc.new { |n| has_an_exact_double_repeat(n.to_s) }
        ]

        count_matching_candidates(low, high, rules)
    end
end

puzzle_input_low = 108457
puzzle_input_high = 562041

puts "Part 1: " + Day04.part1(puzzle_input_low, puzzle_input_high).to_s
puts "Part 2: " + Day04.part2(puzzle_input_low, puzzle_input_high).to_s
