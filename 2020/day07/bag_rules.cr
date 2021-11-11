class BagRules
  class Rule
    getter description : String, contents : Hash(String, Int32)

    def initialize(@description, @contents)
    end

    def self.from_rule_string(rule)
      pattern = /(\w+ \w+) bags contain (.*)\./
      matches = pattern.match(rule).not_nil!
    
      description = matches[1]
      contents = parse_contents_rule(matches[2])
    
      new(description, contents)
    end

    private def self.parse_contents_rule(contents_rule_part)
      contents = {} of String => Int32
      return contents if contents_rule_part == "no other bags"
    
      pattern = /(\d+) (\w+ \w+) bag[s]?/
      while matches = pattern.match(contents_rule_part)
        contents[matches[2]] = matches[1].to_i
        contents_rule_part = matches.post_match
      end
      contents
    end

    def can_contain?(description, rule_set)
      can_contain_directly?(description) || can_contain_nested?(description, rule_set)
    end

    def contents_count(rule_set)
      return 0 if contents.empty?

      contents.sum do |desc, count|
        count + count * rule_set[desc].contents_count(rule_set)
      end
    end

    private def can_contain_directly?(description)
      contents.find { |desc, _count| desc == description } != nil
    end
    
    private def can_contain_nested?(description, rule_set)
      contents.any? do |desc, _count|
        rule = rule_set[desc]
        rule.can_contain?(description, rule_set)
      end
    end
  end

  getter rules : Hash(String, Rule)

  def initialize(@rules)
  end

  def self.parse(rule_lines)
    rules = rule_lines.map(&->Rule.from_rule_string(String))
    new(rules.map { |rule| {rule.description, rule} }.to_h)
  end

  def count_allowed_containers(description)
    rules.count do |_desc, rule|
      rule.can_contain?(description, rules)
    end
  end

  def count_contained_bags(description)
    rules[description].contents_count(rules)
  end
end
