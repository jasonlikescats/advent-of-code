abstract class Mask
  abstract def apply(num : Int64) : Array(Int64)

  protected def parse_mask(mask : String, bit : Int32, unchanged : Char)
    default_bit = bit ^ 1
    mask.gsub(unchanged, "#{default_bit}".chars[0]).to_i64(base: 2)
  end
end

class OverwritingMask < Mask
  PLACEHOLDER_CHAR = 'X'

  getter zero_mask : Int64, one_mask : Int64

  def initialize(mask : String)
    @zero_mask = parse_mask(mask, 0, PLACEHOLDER_CHAR)
    @one_mask = parse_mask(mask, 1, PLACEHOLDER_CHAR)
  end

  def apply(num) : Array(Int64)
    num &= zero_mask
    num |= one_mask
    [num]
  end
end

class AddressMask < Mask
  FLOATING_CHAR = 'X'
  PLACEHOLDER_CHAR = 'Y'

  getter one_mask : Int64, x_masks : Array(OverwritingMask)

  def initialize(mask : String)
    @one_mask = parse_mask(mask, 1, FLOATING_CHAR)
    @x_masks = parse_floating_mask_combinations(change_placeholders(mask))
  end

  def apply(num) : Array(Int64)
    num |= one_mask
    x_masks.flat_map { |mask| mask.apply(num) }
  end

  private def change_placeholders(mask : String)
    mask.gsub({
      '0' => FLOATING_CHAR,
      '1' => FLOATING_CHAR,
      FLOATING_CHAR => PLACEHOLDER_CHAR
    })
  end

  private def parse_floating_mask_combinations(mask : String)
    if mask.chars.any?(PLACEHOLDER_CHAR)
      zero_masks = parse_floating_mask_combinations(mask.sub(PLACEHOLDER_CHAR, '0'))
      one_masks = parse_floating_mask_combinations(mask.sub(PLACEHOLDER_CHAR, '1'))
      zero_masks.concat(one_masks)
    else
      [OverwritingMask.new(mask)]
    end
  end
end
