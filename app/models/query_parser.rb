class QueryParser
    attr_accessor :tree

    class NodeExpression
        attr_accessor :left, :op, :right
        def initialize(left, op, right)
            @left = left
            @op = op
            @right = right
        end
    end

    class NodePlaceholder
    end

    class NodeValue
        attr_accessor :value
        def initialize(value)
            @value = value
        end
    end

    def initialize(text)
        @default_op = "OR"
        @t = QueryTokenizer.new(text)
        @tree = nil
        while true
            exp = get_expression()
            if exp == nil
                break
            end

            if @tree == nil
                @tree = exp
                next
            end

            if exp.is_a?(NodeExpression)
                if exp.left.is_a?(NodePlaceholder)
                    @tree = NodeExpression.new(@tree, exp.op, exp.right)
                else
                    @tree = NodeExpression.new(@tree, @default_op, exp)
                end
            else
                raise "Unexpected expression (#{exp.class})"
            end
        end
    end

    def to_query()
        node_to_query(@tree, nil)
    end

    def to_solr_query(field)
        node_to_query(@tree, field)
    end

    private
        def get_expression(token = nil)
            if token == nil
                token = @t.get_next_token()
            end

            if token == nil
                return nil
            end

            if token == "(" || token == ")"
                return get_expression()
            end

            if token == "OR" || token == "AND" || token == "OR NOT" || token == "AND NOT" || token == "NOT"
                # First token is an operator, this must be a partial expression in which we
                # either parsed the left side before or there isn't a left side (e.g. "NOT text")
                op = token
                right = get_expression()
                return NodeExpression.new(NodePlaceholder.new(), op, right)
            end

            exp = nil
            left = token
            token = @t.get_next_token()
            if token == nil || token == ")"
                exp = NodeValue.new(left)
            else
                if token == "OR" || token == "AND" || token == "OR NOT" || token == "AND NOT" || token == "NOT"
                    # expression with user defined operator
                    op = token
                    right = get_expression()
                    exp = NodeExpression.new(NodeValue.new(left), op, right)
                else
                    op = @default_op
                    right = get_expression(token)
                    exp = NodeExpression.new(NodeValue.new(left), op, right)
                end
            end
            exp
        end

        def node_to_query(node, field)
            if node == nil
                return ""
            end

            if node.is_a?(NodeValue)
                if field == nil
                    return node.value
                else
                    return field + ":" + node.value
                end
            end

            if node.is_a?(NodePlaceholder)
                return ""
            end

            exp1 = node_to_query(node.left, field)
            exp2 = node_to_query(node.right, field)
            "(" + exp1 + " " + node.op + " " + exp2 + ")"
        end
  end