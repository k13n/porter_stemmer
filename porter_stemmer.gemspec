# -*- encoding: utf-8 -*-
require File.expand_path('../lib/porter_stemmer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Wellenzohn"]
  gem.email         = ["kevin.wellenzohn@gmail.com"]
  gem.description   = %q{Porter stemming algorithm}
  gem.summary       = %q{This gem implements the Porter 1 and Porter 2 stemming algorithm}
  gem.homepage      = "https://github.com/k13n/porter_stemmer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "porter_stemmer"
  gem.require_paths = ["lib"]
  gem.version       = PorterStemmer::VERSION
end
