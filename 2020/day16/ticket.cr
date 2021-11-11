require "./field_rule"

class Ticket
  getter values : Array(Int32)

  def initialize(data)
    @values = data.split(',').map(&.to_i)
  end

  def scanning_error_field(field_rules)
    found = field_options(field_rules).find { |value, fields| fields.empty? }
    
    found ? found[0] : 0
  end
  
  def valid?(field_rules)
    scanning_error_field(field_rules) == 0
  end

  def ordered_field_options(field_rules)
    field_options(field_rules).map { |_val, options| options }
  end

  def field_options(field_rules)
    values.map do |value|
      possible_fields = field_rules
        .select { |rule| rule.valid?(value) }
        .map { |rule| rule.name }
      {value, possible_fields}
    end
  end
end
