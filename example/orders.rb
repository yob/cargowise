#****************************************************************
# Sample script that retrieves order data from a logistics company.
#
# USAGE:
#
#   ruby example/orders.rb http://example.com/Tracker/WebService/OrderService.asmx company_code username password
#
#****************************************************************

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

uri, ccode, username, password = *ARGV

Cargowise::Order.register(:ijs, :uri => uri,
                                :code => ccode,
                                :user => username,
                                :password => password)

Cargowise::Order.via(:ijs).by_order_number("13/5/2010").each do |ord|
  puts ord.inspect
  puts
end

Cargowise::Order.via(:ijs).incomplete.each do |ord|
  puts ord.inspect
  puts
end
