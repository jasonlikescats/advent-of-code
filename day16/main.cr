require "file"
require "./field_rule"
require "./ticket"

def load_input
  groups = File.read("input").split("\n\n")

  rules = groups[0].split("\n").map(&->FieldRule.new(String))
  my_ticket = Ticket.new(groups[1].split('\n')[1])
  nearby_tickets = groups[2].split('\n').skip(1).map(&->Ticket.new(String))

  { rules, my_ticket, nearby_tickets }
end

def part1
  rules, my_ticket, nearby_tickets = load_input

  nearby_tickets.sum do |ticket|
    ticket.scanning_error_rate(rules) || 0
  end
end

def part2
  data = load_input
  
  "TODO"
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
