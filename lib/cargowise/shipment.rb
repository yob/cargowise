# coding: utf-8

module Cargowise
  class Shipment < AbstractResult

    attr_reader :number, :housebill, :goods_description, :service_level
    attr_reader :origin, :destination

    attr_reader :shipper_name

    attr_reader :consignee_name

    def initialize(node)
      @node = node

      @number    = text_value("./Number")
      @housebill = text_value("./HouseBill")
      @goods_description = text_value("./GoodsDescription")
      @service_level = text_value("./ServiceLevel")
      @origin        = text_value("./Origin")
      @destination   = text_value("./Destination")
      @etd           = time_value("./ETD")
      @eta           = time_value("./ETA")
      @delivered_date = time_value("./DeliveredDate")

      @shipper_name = text_value("./Shipper/OrganisationDetails/Name")

      @consignee_name = text_value("./Consignee/OrganisationDetails/Name")
    end

    # find all shipments with a ShipmentNumber that matches ref
    #
    def self.find_by_shipment_number(company_code, username, pass, ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => "ShipmentNumber",
            "tns:NumberValue" => ref
          }
        }
      }
      ShipmentsClient.get_shipments_list(company_code, username, pass, filter_hash)
    end

    # find all shipments that haven't been delivered yet.
    #
    # This times out on some systems, possibly because the logistics company
    # isn't correctly marking shipments as delivered, so the result is too
    # large to transfer in a timely manner.
    #
    def self.find_undelivered(company_code, username, pass)
      filter_hash = {
        "tns:Filter" => { "tns:Status" => "Undelivered" }
        }
      ShipmentsClient.get_shipments_list(company_code, username, pass, filter_hash)
    end

    # find all shipments that had some activity in the past seven days. This could
    # include leaving port, being delivered or passing a milestone.
    #
    def self.find_with_recent_activity(company_code, username, pass)
      filter_hash = {
        "tns:Filter" => {
          "tns:Date" => {
            "tns:DateSearchField" => "ALL",
            "tns:FromDate" => (Date.today - 14).strftime("%Y-%m-%d"),
            "tns:ToDate" => (Date.today + 14).strftime("%Y-%m-%d")
          }
        }
      }
      ShipmentsClient.get_shipments_list(company_code, username, pass, filter_hash)
    end

  end
end
