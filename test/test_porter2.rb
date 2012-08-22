require 'test/unit'
require 'porter_stemmer'

class Porter2Test < Test::Unit::TestCase

  # tests whether the Porter2 implementation finds the proper regions in a word
  def test_region
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("beautiful")
    assert_equal [5, 6], PorterStemmer::Porter2.find_regions("beauty")
    assert_equal [4, 4], PorterStemmer::Porter2.find_regions("beau")
    assert_equal [2, 4], PorterStemmer::Porter2.find_regions("animadversion")
    assert_equal [5, 9], PorterStemmer::Porter2.find_regions("sprinkled")
    assert_equal [3, 6], PorterStemmer::Porter2.find_regions("eucharist")
    assert_equal [2, 2], PorterStemmer::Porter2.find_regions("is")

    ## special cases
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("generally")
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("generalization")
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("generalities")
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("generations")
    assert_equal [6, 8], PorterStemmer::Porter2.find_regions("communism")
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("arsenal")
    assert_equal [5, 7], PorterStemmer::Porter2.find_regions("arsenic")
  end

  # checks whether some words are recognized as being short
  def short
    # this are short words
    assert PorterStemmer::Porter2.short?("bed")
    assert PorterStemmer::Porter2.short?("shed")
    assert PorterStemmer::Porter2.short?("shred")

    # this are not short words
    assert !PorterStemmer::Porter2.short?("bead")
    assert !PorterStemmer::Porter2.short?("embed")
    assert !PorterStemmer::Porter2.short?("beds")
  end

  # reads an input file containing a word and its stem, one per line.
  # the test checks whether the Porter2 implementation stems the words properly
  def test_stemming
    data = []
    File.foreach(File.expand_path(File.dirname(__FILE__))+"/porter2_testdata.txt") do |line| 
      data << line.chomp.split(/ /).reject { |e| e.empty? }
    end

    data.each do |input|
      word, stem = input
      assert_equal stem, PorterStemmer::Porter2.stem(word)
    end
  end

end