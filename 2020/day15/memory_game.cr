class MemoryGame
  class Number
    getter turn_numbers : Array(Int32), value : Int32

    def initialize(turn_number, @value)
      @turn_numbers = [] of Int32
      add_turn(turn_number)
    end

    def add_turn(turn_number)
      turn_numbers << turn_number
    end

    def last_two_turn_distance
      return 0 if turn_numbers.size < 2

      turn_numbers[-1] - turn_numbers[-2]
    end
  end

  getter values : Hash(Int32, Number), last : Number

  def initialize(starting_numbers)
    @values = starting_numbers
      .map_with_index { |num, idx| {num, Number.new(idx + 1, num)} }
      .to_h
    @last = values[values.last_key]
  end

  def play(turn_count)
    start = values.size + 1
    start.upto(turn_count, &->play_turn(Int32))

    last.value
  end
  
  private def play_turn(turn_number)
    spoken = last.last_two_turn_distance

    if values.has_key?(spoken)
      spoken_value = values.dig(spoken)
      spoken_value.add_turn(turn_number)
      @last = spoken_value
    else
      @last = Number.new(turn_number, spoken)
      values[spoken] = last
    end
  end
end
