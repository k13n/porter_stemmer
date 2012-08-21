module PorterStemmer::Porter2

  EXCEPTIONAL_STEMS = {
    'skis'   => 'ski',
    'skies'  => 'sky',
    'dying'  => 'die',
    'lying'  => 'lie',
    'tying'  => 'tie',
    'idly'   => 'idl',
    'gently' => 'gentl',
    'ugly'   => 'ugli',
    'early'  => 'earli',
    'only'   => 'onli',
    'singly' => 'singl',
    'sky'    => 'sky',
    'news'   => 'news',
    'howe'   => 'howe',
    'atlas'  => 'atlas',
    'cosmos' => 'cosmos',
    'bias'   => 'bias',
    'andes'  => 'andes'
  }

  EXCEPTIONAL_STEMS_STEP_1A = %w{inning outing canning herring earring proceed exceed succeed}
  EXCEPTIONAL_REGIONS = /^(gener|commun|arsen)/

  STEP_2_LIST = {
    'tional'  => 'tion',
    'enci'    => 'ence',
    'anci'    => 'ance',
    'abli'    => 'able',
    'entli'   => 'ent',
    'izer'    => 'ize',
    'ization' => 'ize',
    'ational' => 'ate',
    'ation'   => 'ate',
    'ator'    => 'ate',
    'alism'   => 'al',
    'aliti'   => 'al',
    'alli'    => 'al',
    'fulness' => 'ful',
    'ousli'   => 'ous',
    'ousness' => 'ous',
    'iveness' => 'ive',
    'iviti'   => 'ive',
    'biliti'  => 'ble',
    'bli'     => 'ble',
    'ogi'     => 'og',
    'fulli'   => 'ful',
    'lessli'  => 'less',
    'li'      => ''
  }

  STEP_3_LIST = {
    'tional'  => 'tion',
    'ational' => 'ate',
    'alize'   => 'al',
    'icate'   => 'ic',
    'iciti'    => 'ic',
    'ical'    => 'ic',
    'ful'     => '',
    'ness'    => '',
    'ative'   => '',
  }

  V  = "[aeiouy]"   # vowel
  C  = "[^aeiou]"   # consonant

  SHORT_END  = /((^#{V}#{C})|(#{C}#{V}[^aeiouywxY]))$/o  # end in short syllable 

  DOUBLE = /(bb|dd|ff|gg|mm|nn|pp|rr|tt)$/o
  VALID_LI_ENDING = "[cdeghkmnrt]"

  def self.find_regions(word)
    if word =~ EXCEPTIONAL_REGIONS
      region1 = $1.length
    else
      region1 = (word =~ /#{V}#{C}/o)
      region1 = (region1.nil?) ? word.size : region1+2
    end

    region2 = (word =~ /.{#{region1}}#{V}#{C}/)
    region2 = region2.nil? ? word.size : region1+region2+2

    return region1, region2
  end

  def self.short?(word, region1)
    region1 >= word.size && word =~ SHORT_END
  end

  def self.stem(word)
    # return if word is too short
    word = word.to_s
    return word if word.length <= 2

    # exceptional forms
    return EXCEPTIONAL_STEMS[word] if EXCEPTIONAL_STEMS.include? word

    # remove an itial ' and mark an initial y as consonant
    word.gsub! /^'/, ''
    word.gsub! /^y/, 'Y'

    region1, region2 = self.find_regions(word)

    # step 0
    word = $` if word =~ /('s'|'s|')$/


    # step 1a
    if word =~ /sses$/
      word.gsub! /sses$/, 'ss'
    elsif word =~ /ie[sd]$/
      sub = $`.length > 1 ? 'i' : 'ie'
      word.gsub! /ie[sd]$/, sub 
    elsif word =~ /#{V}.+s$/ and word !~ /(us|ss)$/
      word.gsub! /s$/, '' 
    end

    # exceptional forms after step 1a
    return word if EXCEPTIONAL_STEMS_STEP_1A.include? word
    
    # step 1b
    if word =~ /(eed|eedly)$/
      stem = $`
      if region1 <= stem.size
        word = stem + 'ee'
      end
    elsif word =~ /#{V}.*(ingly|edly|ing|ed)$/
      word.gsub! /#{$1}$/, ''
      if word =~ /(at|bl|iz)$/
        word += 'e'
      elsif word =~ DOUBLE
        word.chop!
      elsif self.short?(word, region1)
        word += 'e'
      end
    end
    
    # step 1c
    word.gsub! /[yY]$/, 'i' if word =~ /.+#{C}[yY]$/


    # step 2
    if word =~ /(ational|fulness|iveness|ization|ousness|biliti|lessli|tional|ation|alism|aliti|entli|fulli|iviti|ousli|enci|anci|abli|izer|ator|alli|bli)$/
      stem = $`
      suffix = $1
      if region1 <= stem.size
        word = stem + STEP_2_LIST[suffix]
      end
    elsif word =~ /ogi$/
      stem = $`
      if stem.end_with? 'l' and region1 <= stem.size
        word.gsub! /ogi$/, 'og'
      end
    elsif word =~ /(.*#{VALID_LI_ENDING})li$/
      stem = $1
      if region1 <= stem.size
        word.gsub! /li$/, ''
      end
    end
    
    
    # step 3
    if word =~ /(ational|tional|alize|icate|iciti|ical|ness|ful)$/
      stem = $`
      suffix = $1
      if region1 <= stem.size
        word = stem + STEP_3_LIST[suffix]
      end
    elsif word =~ /ative$/
      stem = $`
      if region2 <= stem.size
        word = stem
      end
    end      
    

    # step 4
    if word =~ /(ement|able|ance|ence|ible|ment|ant|ate|ent|ism|iti|ive|ize|ous|al|er|ic|ou)$/
      stem = $`
      if region2 <= stem.size
        word = stem
      end
    elsif word =~ /(.*[st])ion$/
      stem = $1
      if region2 <= stem.size
        word = stem
      end
    end


    # step 5a
    if word =~ /e$/
      stem = $`
      if region2 <= stem.size or (region1 <= stem.size and stem !~ SHORT_END)
        word.chop!
      end
    elsif word =~ /(.*l)l$/
      stem = $1
      if region2 <= stem.size
        word.chop!
      end
    end


    word.gsub! /Y/, 'y'
    word
  end

end