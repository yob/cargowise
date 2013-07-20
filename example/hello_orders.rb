
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

uri, ccode, username, password = *ARGV

client = Cargowise::Client.new(:order_uri => uri,
                               :company_code => ccode,
                               :username => username,
                               :password => password)

puts client.orders_hello
