
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

orders = Cargowise::OrdersClient.get_order_list(ccode, username, password)

orders.each do |ord|
  puts ord.inspect
  puts
end
