class NodeExpression
    attr_accessor :left, :op, :right
    def initialize(left, op, right)
        @left = left
        @op = op
        @right = right
    end
end

class NodeValue
    attr_accessor :value
    def initialize(value)
        @value = value
    end
end

class Parser
    attr_accessor :tree

    def initialize(text)
        @tree = nil
        @t = Tokenizer.new(text)
        # puts text
        # byebug
        while true
            exp = get_expression()
            if exp == nil
                break
            end
            if @tree == nil
                @tree = exp
            else
                @tree = NodeExpression.new(@tree, "OR", exp)
            end
        end
    end

    def get_expression(token = nil)
        if token == nil
            token = @t.get_next_token()
        end
        if token == nil || token == ")"
            return nil
        end
        if token == "("
            return get_expression()
        end
        exp = nil
        left = token
        token = @t.get_next_token()
        if token == nil || token == ")"
            exp = NodeValue.new(left)
        else
            if token == "OR" || token == "AND"
                # AND/OR expression
                op = token
                right = get_expression()
                exp = NodeExpression.new(NodeValue.new(left), op, right)
            else
                # Default to OR expression
                op = "OR"
                right = get_expression(token)
                exp = NodeExpression.new(NodeValue.new(left), op, right)
            end
        end
        exp
    end
  end