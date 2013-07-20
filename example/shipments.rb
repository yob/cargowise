#****************************************************************
# Sample script that retrieves shipment data from a logistics company.
#
# USAGE:
#
#   ruby example/shipments.rb http://example.com/Tracker/WebService/OrderService.asmx company_code username password
#
#****************************************************************

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise'

uri, ccode, username, password = *ARGV

Cargowise::Shipment.register(:ijs, :uri => uri,
                                   :code => ccode,
                                   :user => username,
                                   :password => password)

#Cargowise::Shipment.via(:ijs).with_recent_activity.each do |ship|
#  puts ship.inspect
#  puts
#end

Cargowise::Shipment.via(:ijs).by_shipment_number("SORD30059237").each do |ship|
  puts ship.inspect
  #puts ship.to_xml
  puts ship.kg
  puts ship.cubic_meters
  puts
end
