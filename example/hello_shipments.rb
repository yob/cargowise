
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

uri, ccode, username, password = *ARGV

puts Cargowise::ShipmentsClient.new.hello(uri, ccode, username, password)
