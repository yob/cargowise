
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

uri, ccode, username, password = *ARGV

client = Cargowise::Client.new(:shipment_uri => uri,
                               :company_code => ccode,
                               :username => username,
                               :password => password)

puts client.shipments_hello
