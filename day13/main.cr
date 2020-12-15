require "file"

class BusSchedule
  getter number : Int32

  def initialize(@number)
  end

  def wait(ready_time)
    since_last = ready_time % number
    number - since_last
  end
end

def load_input
  lines = File.read_lines("input")
  ready_time = lines[0].to_i
  schedules = lines[1].split(',').reject!("x").map(&.to_i).map(&->BusSchedule.new(Int32))
  {ready_time, schedules}
end

def part1
  ready_time, schedules = load_input
  schedules
    .map { |sched| {sched.number, sched.wait(ready_time)} }
    .min_by { |_num, wait| wait }
    .product
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
