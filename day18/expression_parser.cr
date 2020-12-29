require "./node"

module ExpressionParser
  OPERATORS = ['+', '*']

  # Parses into an AST using the shunting-yard algorithm (modified
  # for our specific operator precedence quirks)
  # The precedence comparer function provided must return false if
  # argument one has greater precedence than argument two.
  def self.to_tree(equation : String, precedence_comparer : Char, Char -> Bool)
    operators = Array(Char).new
    tree_nodes = Array(Node).new

    equation.chars.each do |token|
      if numeric?(token)
        tree_nodes << Node.new(token)
      elsif operator?(token)
        while !operators.empty? && 
          precedence_comparer.call(token, operators.last) &&
          operators.last != '('
          output_operator(operators.pop, tree_nodes)
        end
        operators << token
      elsif token == '('
        operators << token
      elsif token == ')'
        while !operators.empty? && operators.last != '('
          output_operator(operators.pop, tree_nodes)
        end

        if !operators.empty? && operators.last == '('
          operators.pop
        end
      end
    end

    while !operators.empty?
      output_operator(operators.pop, tree_nodes)
    end

    raise "Parse failed" unless tree_nodes.size == 1

    tree_nodes.first
  end

  private def self.numeric?(token)
    token.number?
  end

  private def self.operator?(token)
    OPERATORS.includes?(token)
  end

  private def self.output_operator(operator, tree_nodes)
    r = tree_nodes.pop
    l = tree_nodes.pop
    tree_nodes << Node.new(operator, l, r)
  end
end
