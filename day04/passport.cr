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
    required_fields? #&& TODO
  end
end
