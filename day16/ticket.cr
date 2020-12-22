require "./field_rule"

class Ticket
  getter values : Array(Int32)

  def initialize(data)
    @values = data.split(',').map(&.to_i)
  end

  def scanning_error_rate(field_rules : Array(FieldRule))
    values.find do |value|
      !field_rules.any? { |rule| rule.valid?(value) }
    end
  end
end
