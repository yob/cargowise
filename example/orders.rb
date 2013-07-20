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

client = Cargowise::Client.new(:order_uri => uri,
                               :company_code => ccode,
                               :username => username,
                               :password => password)

client.orders.by_order_number("9668").each do |ord|
  puts ord.inspect
  puts
end

client.orders.incomplete.each do |ord|
  puts ord.inspect
  puts
end
