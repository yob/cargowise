
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

puts Cargowise::OrdersClient.hello(ccode, username, password)
