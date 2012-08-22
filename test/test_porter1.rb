require 'test/unit'
require 'porter_stemmer'

class Porter1Test < Test::Unit::TestCase

  # tests the regular expression to check whether 
  # the measure of a word is greater than 0
  def test_m_greater_0
    assert_equal nil, "tr" =~ PorterStemmer::Porter1::MGR0
    assert_equal nil, "ee" =~ PorterStemmer::Porter1::MGR0
    assert_equal nil, "tree" =~ PorterStemmer::Porter1::MGR0
    assert_equal nil, "y" =~ PorterStemmer::Porter1::MGR0
    assert_equal nil, "by" =~ PorterStemmer::Porter1::MGR0
    assert_not_nil "crepuscular" =~ PorterStemmer::Porter1::MGR0
  end

  # tests the regular expression to check whether 
  # the measure of a word is greater than 1
  def test_m_equal_1
    assert_not_nil "trouble" =~ PorterStemmer::Porter1::MEQ1
    assert_not_nil "oats" =~ PorterStemmer::Porter1::MEQ1
    assert_not_nil "trees" =~ PorterStemmer::Porter1::MEQ1
    assert_not_nil "ivy" =~ PorterStemmer::Porter1::MEQ1
  end

  # tests the regular expression to check whether 
  # the measure of a word is equal to 1
  def test_m_greater_1
    assert_not_nil "troubles" =~ PorterStemmer::Porter1::MGR1
    assert_not_nil "private" =~ PorterStemmer::Porter1::MGR1
    assert_not_nil "oaten" =~ PorterStemmer::Porter1::MGR1
    assert_not_nil "orrery" =~ PorterStemmer::Porter1::MGR1
    assert_not_nil "crepuscular" =~ PorterStemmer::Porter1::MGR1
  end

  def test_stemming
    data = []
    current_dir = File.expand_path(File.dirname(__FILE__))
    voc_file = File.new(current_dir+"/porter1_vocabulary.txt", "r")
    out_file = File.new(current_dir+"/porter1_output.txt", "r")
    while ((word = voc_file.gets) && (stem = out_file.gets)) 
      data << [word.chop, stem.chop]
    end
    voc_file.close
    out_file.close

    data.each do |input|
      word, stem = input
      assert_equal stem, PorterStemmer::Porter1.stem(word)
    end
  end

end