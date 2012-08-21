module PorterStemmer::Porter1

  STEP_2_LIST = {
    'ational' => 'ate',
    'tional'  => 'tion',
    'enci'    => 'ence',
    'anci'    => 'ance',
    'izer'    => 'ize',
    'bli'     => 'ble',
    'alli'    => 'al',
    'entli'   => 'ent',
    'eli'     => 'e',
    'ousli'   => 'ous',
    'ization' => 'ize',
    'ation'   => 'ate',
    'ator'    => 'ate',
    'alism'   => 'al',
    'iveness' => 'ive',
    'fulness' => 'ful',
    'ousness' => 'ous',
    'aliti'   => 'al',
    'iviti'   => 'ive',
    'biliti'  => 'ble',
    'logi'    => 'log'
  }

  STEP_3_LIST = {
    'icate'   => 'ic',
    'ative'   => '',
    'alize'   => 'al',
    'iciti'    => 'ic',
    'ical'    => 'ic',
    'ful'     => '',
    'ness'    => ''
  }

  V  = "[aeiouy]"   # vowel
  C  = "[^aeiou]"   # consonant

  MGR0 = /^#{C}*#{V}+#{C}/o             # m greater 0
  MGR1 = /^#{C}*#{V}+#{C}+#{V}+#{C}/o   # m greater 1
  MEQ1 = /^#{C}*#{V}+#{C}+#{V}*$/o      # m equals  1

  CVC  = /#{C}#{V}[^aeiouywxY]$/o

  def self.stem(word)
    word = word.to_s
    return word if word.length <= 2

    # mark an initial y as consonant
    word.gsub! /^y/, 'Y'

    # step 1a
    case word
      when /sses$/  then word.gsub! /sses$/, 'ss'
      when /ies$/   then word.gsub! /ies$/, 'i'
      when /ss$/    then # do nothing
      when /s$/     then word.chop!
    end
    
    # step 1b
    if word =~ /eed$/
      stem = $`
      if stem =~ MGR0
        word.chop!
      end
    elsif word =~ /#{V}.*(ing|ed)$/
      word.gsub! /#{$1}$/, ''
      if word =~ /(at|bl|iz)$/
        word += 'e'
      elsif word =~ /(bb|dd|ff|gg|mm|nn|pp|rr|tt)$/
        word.chop!
      elsif word =~ CVC and word =~ MEQ1
        word += 'e'
      end
    end
    
    # step 1c
    if word =~ /#{V}.*y$/
      word.gsub! /y$/, 'i' 
    end


    # step 2
    if word =~ /(ational|fulness|iveness|ization|ousness|biliti|tional|alism|aliti|ation|entli|iviti|ousli|anci|alli|ator|enci|izer|logi|bli|eli)$/
      stem = $`
      suffix = $1
      if stem =~ MGR0
        word = stem + STEP_2_LIST[suffix]
      end
    end
    
    
    # step 3
    if word =~ /(alize|ative|icate|iciti|ical|ness|ful)$/
      stem = $`
      suffix = $1
      if stem =~ MGR0
        word = stem + STEP_3_LIST[suffix]
      end
    end
    

    # step 4
    if word =~ /(ement|able|ance|ence|ible|ment|ant|ate|ent|ism|iti|ive|ize|ous|al|er|ic|ou)$/
      stem = $`
      if stem =~ MGR1
        word = stem
      end
    elsif word =~ /(.*[st])ion$/
      stem = $1
      if stem =~ MGR1
        word = stem
      end
    end


    # step 5a
    if word =~ /e$/
      stem = $`
      if stem =~ MGR1
        word.chop!
      elsif stem =~ MEQ1 and stem !~ CVC
        word = stem
      end
    end


    # step 5b
    if word =~ /ll$/ and word =~ MGR1
      word.chop!
    end

    word.gsub! /Y/, 'y'
    word
  end

end