require "file"

class PersonCustoms
  getter answers : Array(Char)

  def initialize(answers)
    @answers = answers.chars
  end
end

class GroupCustoms
  getter members : Array(PersonCustoms)

  def initialize(group_answers)
    @members = group_answers
      .strip
      .split('\n')
      .map(&->PersonCustoms.new(String))
  end

  def any_yes_answers
    members
      .map(&.answers)
      .flatten
      .uniq
  end

  def all_yes_answers
    members
      .map(&.answers)
      .reduce { |accum_answers, person_answers| accum_answers & person_answers }
  end
end

def load_groups
  File
    .read("input")
    .split("\n\n")
    .map(&->GroupCustoms.new(String))
end

def part1
  load_groups.sum { |group| group.any_yes_answers.size }
end

def part2
  load_groups.sum { |group| group.all_yes_answers.size }
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
