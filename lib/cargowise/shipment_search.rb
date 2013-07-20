# coding: utf-8

module Cargowise

  class ShipmentSearch

    def initialize(savon_client)
      @savon_client = savon_client
    end

    # find all shipments with a MasterBillNumber that matches ref
    #
    def by_masterbill_number(ref)
      by_number("MasterBillNumber", ref)
    end

    # find all shipments with a ShipmentNumber that matches ref
    #
    def by_shipment_number(ref)
      by_number("ShipmentNumber", ref)
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
      get_shipments_list(filter_hash)
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
      get_shipments_list(filter_hash)
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
      get_shipments_list(filter_hash)
    end

    private

    def by_number(field, ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => field,
            "tns:NumberValue" => ref
          }
        }
      }
      get_shipments_list(filter_hash)
    end

    # return an array of shipments. Each shipment should correspond to
    # a consolidated shipment from the freight company.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_shipments_list(filter_hash)
      response = @savon_client.call(:get_shipments_list, message: filter_hash)
      response.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Shipment.new(node)
      end
    end

  end
end

