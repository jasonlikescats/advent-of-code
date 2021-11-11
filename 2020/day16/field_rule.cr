class FieldRule
  class Range
    def initialize(@min : Int32, @max : Int32)
    end

    def valid?(number)
      number >= @min && number <= @max
    end
  end

  getter name : String, ranges : Array(Range)

  def initialize(description)
    matches = description.match(/([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/).not_nil!
    @name = matches[1]
    @ranges = [
      Range.new(matches[2].to_i, matches[3].to_i),
      Range.new(matches[4].to_i, matches[5].to_i)
    ]
  end

  def valid?(number)
    ranges.any? { |r| r.valid?(number) }
  end
end
