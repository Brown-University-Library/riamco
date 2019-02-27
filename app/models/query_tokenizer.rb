class QueryTokenizer
  def initialize(text)
    @text = text
    @pos = 0
    @length = text.length
  end

  def get_next_token()
    advance_white_space()
    c = @text[@pos]
    if c == '"'
      token = get_quoted_text()
    else
      token = get_spaced_text()
      if (token == "AND" || token == "OR") && peek_next_token() == "NOT"
        token += " " + get_next_token()
      end
    end
    token
  end

  private
    def advance_white_space()
      while @text[@pos] == ' '
        @pos += 1
      end
    end

    def get_quoted_text()
      token = @text[@pos]
      @pos += 1
      while @pos < @length
        c = @text[@pos]
        token += c
        @pos += 1
        break if c == '"'
      end
      token
    end

    def get_spaced_text()
      token = nil
      while @pos < @length
        c = @text[@pos]
        if c == ' '
          if token == nil
            # eat this character
            @pos += 1
          else
            # we are done
            @pos += 1
            break
          end
        elsif c == "(" || c == ")"
          if token == nil
            # we are done
            token = c
            @pos += 1
            break
          else
            # stop, but don't eat this character so we
            # pick it up again in the next call
            break
          end
        else
          if token ==  nil
            token = c
          else
            token += c
          end
          @pos += 1
        end
      end
      token
    end

    def peek_next_token()
      saved_pos = @pos
      token = get_next_token()
      @pos = saved_pos
      token
    end
end