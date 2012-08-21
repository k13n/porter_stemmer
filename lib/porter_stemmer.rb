module PorterStemmer
end

# require all ruby files in the porter_stemmer directory
Dir[File.dirname(__FILE__) + '/porter_stemmer/*.rb'].each do |file| 
  require file 
end