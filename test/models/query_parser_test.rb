require "minitest/autorun"
require "./app/models/query_parser.rb"

class QueryParserTest < Minitest::Test
  def test_basics
    # dogs
    p = QueryParser.new('dogs')
    assert_equal p.tree.value, "dogs"

    # (dogs OR cats)
    p = QueryParser.new('dogs cats')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "OR"
    assert_equal p.tree.right.value, "cats"

    # (dogs AND cats)
    p = QueryParser.new('dogs AND cats')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "AND"
    assert_equal p.tree.right.value, "cats"

    # dogs OR (cats OR birds)
    p = QueryParser.new('dogs cats birds')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "OR"
    assert_equal p.tree.right.left.value, "cats"
    assert_equal p.tree.right.op, "OR"
    assert_equal p.tree.right.right.value, "birds"

    # (dogs AND cats)
    p = QueryParser.new('dogs AND cats')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "AND"
    assert_equal p.tree.right.value, "cats"

    # dogs AND (cats AND birds)
    p = QueryParser.new('dogs AND cats AND birds')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "AND"
    assert_equal p.tree.right.left.value, "cats"
    assert_equal p.tree.right.op, "AND"
    assert_equal p.tree.right.right.value, "birds"
  end

  def test_not_operators
    p = QueryParser.new('NOT dogs')
    assert_equal p.tree.op, "NOT"
    assert_equal p.tree.right.value, "dogs"

    # (dogs AND NOT cats)
    p = QueryParser.new('dogs AND NOT cats')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "AND NOT"
    assert_equal p.tree.right.value, "cats"

    # dogs OR NOT (cats AND birds)
    p = QueryParser.new('dogs OR NOT cats AND birds')
    assert_equal p.tree.left.value, "dogs"
    assert_equal p.tree.op, "OR NOT"
    assert_equal p.tree.right.left.value, "cats"
    assert_equal p.tree.right.op, "AND"
    assert_equal p.tree.right.right.value, "birds"
  end

  def test_parenthesis
    p = QueryParser.new('(dogs AND cats)')
    assert_equal "dogs", p.tree.left.value
    assert_equal "AND", p.tree.op
    assert_equal "cats", p.tree.right.value

    p = QueryParser.new('(dogs AND cats) OR birds')
    assert_equal "dogs", p.tree.left.left.value
    assert_equal "AND", p.tree.left.op
    assert_equal "cats", p.tree.left.right.value
    assert_equal "OR", p.tree.op
    assert_equal "birds", p.tree.right.value

    p = QueryParser.new('(dogs AND cats) AND birds')
    assert_equal "dogs", p.tree.left.left.value
    assert_equal "AND", p.tree.left.op
    assert_equal "cats", p.tree.left.right.value
    assert_equal "AND", p.tree.op
    assert_equal "birds", p.tree.right.value

    p = QueryParser.new('dogs AND (cats OR birds)')
    assert_equal "dogs", p.tree.left.value
    assert_equal "AND", p.tree.op
    assert_equal "cats", p.tree.right.left.value
    assert_equal "OR", p.tree.right.op
    assert_equal "birds", p.tree.right.right.value

    p = QueryParser.new('"blue dogs" AND ("red cats" OR "green birds")')
    assert_equal '"blue dogs"', p.tree.left.value
    assert_equal "AND", p.tree.op
    assert_equal '"red cats"', p.tree.right.left.value
    assert_equal "OR", p.tree.right.op
    assert_equal '"green birds"', p.tree.right.right.value

    p = QueryParser.new('(blue OR (red yellow)) AND car AND vehicle')
    assert_equal "blue", p.tree.left.left.value
    assert_equal "OR", p.tree.left.op
    assert_equal "red", p.tree.left.right.left.value
    assert_equal "OR", p.tree.left.right.op
    assert_equal "yellow", p.tree.left.right.right.value
    assert_equal "car", p.tree.right.left.value
    assert_equal "AND", p.tree.right.op
    assert_equal "vehicle", p.tree.right.right.value
  end

  def test_to_query()
    p = QueryParser.new('dogs')
    assert_equal "dogs",  p.to_query

    p = QueryParser.new('NOT dogs')
    assert_equal "( NOT dogs)",  p.to_query

    p = QueryParser.new('dogs AND cats')
    assert_equal "(dogs AND cats)",  p.to_query

    p = QueryParser.new('dogs AND cats OR birds')
    assert_equal "(dogs AND (cats OR birds))",  p.to_query

    p = QueryParser.new('dogs AND NOT cats OR birds')
    assert_equal "(dogs AND NOT (cats OR birds))",  p.to_query
  end
end