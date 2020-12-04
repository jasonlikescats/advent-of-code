require "file"

class Passport
  REQUIRED_FIELDS = %w[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
  ]

  getter fields

  def initialize(@fields : Hash(String, String))
  end

  def valid?
    REQUIRED_FIELDS.all? do |required_field|
      fields.has_key?(required_field)
    end
  end
end

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

  passports_data.map { |data| parse_passport(data) }
end

def part1
  data = load_input
  passports = parse_input(data)

  passports.count(&.valid?)
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
