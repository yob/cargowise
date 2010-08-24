
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

puts Cargowise::ShipmentsClient.hello(ccode, username, password)
