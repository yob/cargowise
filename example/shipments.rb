
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

shipments = Cargowise::ShipmentsClient.get_shipments_list(ccode, username, password)

shipments.each do |ship|
  puts ship.inspect
  puts
end
