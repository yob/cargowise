# coding: utf-8

module Cargowise

  # A purchase order that is being shipped to from a supplier to
  # you via a logistics company.
  #
  # Typcially you will setup an arrangement with your account manager
  # where they are sent copies of POs so they can be entered into the
  # database and tracked.
  #
  # All order objects are read-only, see the object attributes to see
  # what information is available.
  #
  # Use class find methods to retrieve order info from your logistics
  # company.
  #
  #     Order.find_by_order_number(...)
  #     Order.find_incomplete(...)
  #     etc
  #
  class Order < AbstractResult

    attr_reader :order_number, :order_status, :description, :datetime
    attr_reader :order_total, :transport_mode, :container_mode

    attr_reader :buyer_name

    attr_reader :supplier_name

    attr_reader :shipments

    def initialize(node)
      @node = node

      @order_number = text_value("./OrderIdentifier/OrderNumber")
      @order_status = text_value("./OrderDetail/OrderStatus")
      @description  = text_value("./OrderDetail/Description")
      @datetime     = time_value("./OrderDetail/OrderDateTime")
      @order_total  = decimal_value("./OrderDetail/OrderTotal")
      @transport_mode = text_value("./OrderDetail/TransportMode")
      @container_mode = text_value("./OrderDetail/ContainerMode")

      @buyer_name   = text_value("./OrderDetail/Buyer/OrganisationDetails/Name")

      @supplier_name = text_value("./OrderDetail/Supplier/OrganisationDetails/Name")

      @shipments = node_array("./Shipment").map { |node|
        Shipment.new(node)
      }
    end

    # find all shipments with a ShipmentNumber that matches ref
    #
    def self.find_by_order_number(company_code, username, pass, ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => "OrderNumber",
            "tns:NumberValue" => ref
          }
        }
      }
      OrdersClient.get_order_list(company_code, username, pass, filter_hash)
    end

    def self.find_incomplete(company_code, username, pass)
      filter_hash = {
        "tns:Filter" => { "tns:OrderStatus" => "INC" }
        }
      OrdersClient.get_order_list(company_code, username, pass, filter_hash)
    end
  end

end
