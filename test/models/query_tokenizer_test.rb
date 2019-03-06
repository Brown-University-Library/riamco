require "minitest/autorun"
require "./app/models/query_tokenizer.rb"

class QueryTokenizerTest < Minitest::Test
  def test_basics
    t = QueryTokenizer.new("hello world")
    assert_equal "hello", t.get_next_token()
    assert_equal "world", t.get_next_token()
    assert_nil t.get_next_token()

    t = QueryTokenizer.new('"hello world"')
    assert_equal '"hello world"', t.get_next_token()
    assert_nil t.get_next_token()

    t = QueryTokenizer.new('"hello world" dog  "hola  mundo" cat')
    assert_equal '"hello world"', t.get_next_token()
    assert_equal "dog", t.get_next_token()
    assert_equal '"hola  mundo"', t.get_next_token()
    assert_equal "cat", t.get_next_token()
    assert_nil t.get_next_token()

    t = QueryTokenizer.new('dogs AND cats')
    assert_equal "dogs", t.get_next_token()
    assert_equal "AND", t.get_next_token()
    assert_equal "cats", t.get_next_token()
    assert_nil t.get_next_token()

    t = QueryTokenizer.new('"dogs AND cats" OR birds')
    assert_equal '"dogs AND cats"', t.get_next_token()
    assert_equal "OR", t.get_next_token()
    assert_equal "birds", t.get_next_token()
    assert_nil t.get_next_token()
  end
end