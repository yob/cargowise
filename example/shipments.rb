
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

ccode, username, password = *ARGV

shipments = Cargowise::Shipment.find_with_recent_activity(ccode, username, password)

shipments.each do |ship|
  puts ship.inspect
  puts
end
