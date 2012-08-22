# PorterStemmer

PorterStemmer implements the porter stemming algorithm in 
[version 1](http://snowball.tartarus.org/algorithms/english/stemmer.html) and 
[version 2](http://snowball.tartarus.org/algorithms/porter/stemmer.html). 
It is written in pure Ruby and does not depend on any extensions, therefore it is platform independent. 
However, there are much faster implementations using native extensions which are linked below. 

## Installation

Add this line to your application's Gemfile:

    gem 'porter_stemmer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install porter_stemmer

## Usage

You can use PorterStemmer as follows:
    
    PorterStemmer::Porter1.stem("generalization")
    PorterStemmer::Porter2.stem("generalization")

Since the Porter 2 algorithm should be used by default, the following shortcut was added:

    PorterStemmer.stem("generalization")


## Known Bugs

According to the [testfile](http://snowball.tartarus.org/algorithms/english/diffs.txt) for the Poter 2 implementation 
from the official website the word **kinkajou** should be stemmed again to **kinkajou**, but the Poter2 implementation
stems the word to **kinkaj**. Since this is the only known word that does not stem properly, an exceptional case was
added to the code such that the tests pass. If you know why the word is stemmed like this, please let me know.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Alternative Stemmers for Ruby

  * [lingua/stemmer](https://github.com/aurelian/ruby-stemmer) (ext)