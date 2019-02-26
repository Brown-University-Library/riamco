class Tokenizer
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
    end
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
end