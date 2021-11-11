class Passport
  REQUIRED_FIELDS = %w[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
  ]

  getter fields

  def initialize(@fields : Hash(String, String))
  end

  def required_fields?
    REQUIRED_FIELDS.all? do |required_field|
      fields.has_key?(required_field)
    end
  end

  def valid?
    required_fields? && fields_valid?
  end

  private def fields_valid?
    birth_year_valid? &&
    issue_year_valid? &&
    expiration_year_valid? &&
    height_valid? &&
    hair_color_valid? &&
    eye_color_valid? &&
    passport_id_valid? &&
    country_id_valid?
  end

  private def birth_year_valid?
    valid_year_in_range?(fields["byr"], 1920, 2002)
  end

  private def issue_year_valid?
    valid_year_in_range?(fields["iyr"], 2010, 2020)
  end

  private def expiration_year_valid?
    valid_year_in_range?(fields["eyr"], 2020, 2030)
  end

  private def height_valid?
    case fields["hgt"]
    when /(\d+)cm/
      $1.to_i >= 150 && $1.to_i <= 193
    when /(\d+)in/
      $1.to_i >= 59 && $1.to_i <= 76
    else
      false
    end
  end

  private def hair_color_valid?
    /#[a-z0-9]+/.match(fields["hcl"])
  end

  private def eye_color_valid?
    %w[
      amb
      blu
      brn
      gry
      grn
      hzl
      oth
    ].includes?(fields["ecl"])
  end

  private def passport_id_valid?
    /^\d{9}$/.match(fields["pid"])
  end

  private def country_id_valid?
    true
  end

  private def valid_year_in_range?(value, min, max)
    value.size == 4 && value.to_i >= min && value.to_i <= max
  end
end
