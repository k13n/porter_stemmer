require "porter_stemmer/version"

Dir[File.dirname(__FILE__) + '/porter_stemmer/*.rb'].each do |file| 
  puts file
  require file 
end