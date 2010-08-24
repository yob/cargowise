
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

orders = Cargowise::Order.find_by_order_number(ccode, username, password, "13/5/2010")

orders.each do |ord|
  puts ord.inspect
  puts
end
