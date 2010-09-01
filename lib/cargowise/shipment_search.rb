# coding: utf-8

module Cargowise

  class ShipmentSearch < AbstractSearch

    # find all shipments with a ShipmentNumber that matches ref
    #
    def by_shipment_number(ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => "ShipmentNumber",
            "tns:NumberValue" => ref
          }
        }
      }
      ShipmentsClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      ShipmentsClient.get_shipments_list(ep.code, ep.user, ep.password, filter_hash)
    end

    # find all shipments that haven't been delivered yet.
    #
    # This times out on some systems, possibly because the logistics company
    # isn't correctly marking shipments as delivered, so the result is too
    # large to transfer in a timely manner.
    #
    def undelivered
      filter_hash = {
        "tns:Filter" => { "tns:Status" => "Undelivered" }
        }
      ShipmentsClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      ShipmentsClient.get_shipments_list(ep.code, ep.user, ep.password, filter_hash)
    end

    # find all shipments that had some activity in the past fourteen days. This could
    # include leaving port, being delivered or passing a milestone.
    #
    def with_recent_activity
      filter_hash = {
        "tns:Filter" => {
          "tns:Date" => {
            "tns:DateSearchField" => "ALL",
            "tns:FromDate" => (Date.today - 14).strftime("%Y-%m-%d"),
            "tns:ToDate" => (Date.today + 14).strftime("%Y-%m-%d")
          }
        }
      }
      ShipmentsClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      ShipmentsClient.get_shipments_list(ep.code, ep.user, ep.password, filter_hash)
    end

    # find all shipments that had were shipped in the past 14 days or will ship in
    # the next 14 days
    #
    def recently_shipped
      filter_hash = {
        "tns:Filter" => {
          "tns:Date" => {
            "tns:DateSearchField" => "ETD",
            "tns:FromDate" => (Date.today - 14).strftime("%Y-%m-%d"),
            "tns:ToDate" => (Date.today + 14).strftime("%Y-%m-%d")
          }
        }
      }
      ShipmentsClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      ShipmentsClient.get_shipments_list(ep.code, ep.user, ep.password, filter_hash)
    end


  end
end

