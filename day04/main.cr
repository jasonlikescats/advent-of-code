require "file"
require "./passport"

def load_input
  File.read_lines("input")
end

def parse_passport(passport_data)
  fields = passport_data
    .strip
    .split(' ')
    .map(&.split(':'))
    .to_h

  Passport.new(fields)
end

def parse_input(lines)
  passports_data = Array(String).new

  passport_data = ""
  lines.each do |line|
    if line.empty?
      passports_data << passport_data
      passport_data = ""
    else
      passport_data += " #{line}"
    end
  end
  passports_data << passport_data

  passports_data.map(&->parse_passport(String))
end

def get_passports
  data = load_input
  parse_input(data)
end

def part1
  get_passports.count(&.required_fields?)
end

def part2
  get_passports.count(&.valid?)
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
