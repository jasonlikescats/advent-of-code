require "./ticket"

module TicketFieldDeducer
  def self.deduce(tickets, rules)
    options = options_by_position(tickets, rules)

    while !resolved?(options)
      options.each do |pos, opts|
        others = other_options(options, pos)
        reduced_options = others.reduce(opts) { |acc, others| acc - others }

        options[pos] = reduced_options unless reduced_options.empty?
      end
    end

    options.map { |pos, opts| {pos, opts.first} }.to_h
  end

  private def self.options_by_position(tickets, rules)
    ticket_options = tickets.map { |ticket| ticket.ordered_field_options(rules) }

    options_by_position = Hash(Int32, Array(String)).new { |h, k| h[k] = Array(String).new }

    field_count = ticket_options.first.size
    0.upto(field_count - 1).each do |idx|
      common = ticket_options
        .map { |ticket| ticket[idx] }
        .reduce { |acc, i| acc & i }

      options_by_position[idx].concat(common)
    end

    options_by_position
  end

  private def self.resolved?(field_options)
    field_options.all? { |_, opts| opts.size == 1 }
  end

  private def self.other_options(field_options, current_position)
    field_options
      .select { |p, _| current_position != p }
      .map { |_, o| o }
      .as(Array(Array(String)))
  end
end
