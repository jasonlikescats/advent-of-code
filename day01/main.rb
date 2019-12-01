module Day01
    class FuelCalculator
        def self.get_module_fuel_naive(mass)
            calculated = mass / 3 - 2
            bounded = [calculated, 0].max
            bounded
        end

        def self.get_module_fuel_recursive(mass)
            fuel = get_module_fuel_naive(mass)
            total_fuel = fuel
            while fuel > 0 do
                fuel = get_module_fuel_naive(fuel)
                total_fuel += fuel
            end
            total_fuel
        end
    end

    def self.accumulate(values)
        values.reduce(0, :+)
    end

    def self.part1(masses)
        accumulate(
            masses.map(&FuelCalculator.method(:get_module_fuel_naive)))
    end

    def self.part2(masses)
        accumulate(
            masses.map(&FuelCalculator.method(:get_module_fuel_recursive)))
    end
end

masses = File.readlines("input.txt").map { |str| str.to_i }
puts "Part 1: " + Day01.part1(masses).to_s
puts "Part 2: " + Day01.part2(masses).to_s
