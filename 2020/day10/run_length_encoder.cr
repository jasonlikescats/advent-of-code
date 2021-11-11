class RunLengthEncoder(T)
  class Entry(T)
    getter value : T, count : Int32

    def initialize(@value : T)
      @count = 1
    end

    def add_to_count
      @count += 1
    end
  end

  def self.encode(array : Array(T))
    encoded = [] of Entry(T)
    array.each_with_index do |n, idx|
      last_enc = encoded.empty? ? nil : encoded.last
  
      if last_enc && last_enc.value == n
        last_enc.not_nil!.add_to_count
      else
        encoded << Entry.new(n)
      end
    end
    encoded
  end
end