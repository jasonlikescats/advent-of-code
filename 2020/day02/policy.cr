abstract class Policy
  getter num1 : UInt8
  getter num2 : UInt8
  getter char : Char

  def initialize(@num1, @num2, @char)
  end

  abstract def evaluate(password)
end

class SledRentalPolicy < Policy
  def evaluate(password)
    count = password.count { |c| c == char }
    count >= min && count <= max
  end

  private def min
    @num1
  end

  private def max
    @num2
  end
end

class TobogganRentalPolicy < Policy
  def evaluate(password)
    pos1 = char_at_position?(num1, password)
    pos2 = char_at_position?(num2, password)
    
    pos1 ^ pos2
  end

  private def char_at_position?(position, password)
    position -= 1 # adjust for 1-based indexing
    password[position] == char
  end
end
