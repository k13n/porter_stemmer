module PorterStemmer
end

# require all ruby files in the porter_stemmer directory
current_path = File.expand_path(File.dirname(__FILE__))
Dir[current_path + '/lib/**/*.rb'].uniq.each do |file|
  require file
end