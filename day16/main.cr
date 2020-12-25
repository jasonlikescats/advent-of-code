require "file"
require "./field_rule"
require "./ticket"
require "./ticket_field_deducer"

def load_input
  groups = File.read("input").split("\n\n")

  rules = groups[0].split("\n").map(&->FieldRule.new(String))
  my_ticket = Ticket.new(groups[1].split('\n')[1])
  nearby_tickets = groups[2].split('\n').skip(1).map(&->Ticket.new(String))

  { rules, my_ticket, nearby_tickets }
end

def part1
  rules, my_ticket, nearby_tickets = load_input

  nearby_tickets.sum { |ticket| ticket.scanning_error_field(rules) }
end

def part2
  rules, my_ticket, nearby_tickets = load_input
  
  valid_nearby_tickets = nearby_tickets.select { |ticket| ticket.valid?(rules) }

  field_mapping = TicketFieldDeducer.deduce(valid_nearby_tickets, rules)

  departure_field_indices = field_mapping
                              .select { |_idx, field| field.starts_with?("departure") }
                              .map { |idx, _field| idx }

  my_departure_values = departure_field_indices.map { |idx| my_ticket.values[idx].to_i64 }
  my_departure_values.product
end

puts "Part 1 Result: \n#{part1}"
puts "\n"
puts "Part 2 Result: \n#{part2}"
