class Node
  getter value : Char, left : Node?, right : Node?

  def initialize(@value, @left = nil, @right = nil)
  end

  def evaluate
    return value.to_i64 if left.nil? && right.nil?

    l = left.not_nil!
    r = right.not_nil!

    case value
    when '+'
      l.evaluate + r.evaluate
    when '*'
      l.evaluate * r.evaluate
    else
      raise "Unknown operator #{value}"
    end
  end
end
