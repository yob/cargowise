# coding: utf-8

module Cargowise

  # A shipment that is currently on its way to you. Could take on a
  # variety of forms - carton, palet, truck? Could be travelling via
  # air, sea, road, rail, donkey?
  #
  # Typcially you will lookup the status of a shipment you're aware of
  # using the shipment number:
  #
  #     Shipment.find_by_shipment_number(...)
  #
  # If you want all recent shipments (delivered and undelivered) to
  # ensure you know what's coming:
  #
  #     Shipment.find_with_recent_activity(...)
  #
  # All shipment objects are read-only, see the object attributes to see
  # what information is available.
  #
  class Shipment < AbstractResult

    attr_reader :number, :housebill, :goods_description, :service_level
    attr_reader :origin, :destination, :etd, :eta, :delivered_date

    attr_reader :shipper_name

    attr_reader :consignee_name

    attr_reader :documents

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

      @documents = node_array("./DocumentLinks/DocumentLink").map { |node|
        Document.new(node)
      }.sort_by { |doc|
        doc.date
      }
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
