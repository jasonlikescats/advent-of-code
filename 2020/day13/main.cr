require "file"

class BusSchedule
  getter interval : Int64, offset : Int32

  def initialize(@interval, @offset)
  end

  def wait(time)
    since_last = time % interval
    return 0 if since_last == 0

    interval - since_last
  end

  def next_arrival(start_time, search_step_size)
    start_time.step(by: search_step_size) do |time|
      return time if wait(time + offset) == 0
    end
  end
end

def load_input
  lines = File.read_lines("input")
  ready_time = lines[0].to_i
  intervals = lines[1].split(',')
  busses = Array(BusSchedule).new
  intervals.each_with_index do |interval, offset|
    next if interval == "x"

    busses << BusSchedule.new(interval.to_i64, offset)
  end
  {ready_time, busses}
end

def part1
  ready_time, schedules = load_input
  schedules
    .map { |sched| {sched.interval, sched.wait(ready_time)} }
    .min_by { |_num, wait| wait }
    .product
end

def part2
  _, busses = load_input

  time = 0_i64
  step_size = 1_i64
  busses.each do |bus|
    time = bus.next_arrival(time, step_size)

    # We can take bigger steps so long as they align with all our bus
    # intervals evaluated so far. There's a danger that we overstep
    # the increase by using multiplication here and we should evaluate
    # the lowest common multiple instead, but luckily our input numbers
    # have the property that lcm(x, y) == x * y (there's probably a fancy
    # term for that).
    step_size *= bus.interval
  end

  time
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
