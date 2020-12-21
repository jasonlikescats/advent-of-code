class MaskedOperation
  getter address : Int64, value : Int64, mask : Mask

  def initialize(@address, @value, @mask)
  end

  def apply_mask(value)
    mask.apply(value)
  end
end
