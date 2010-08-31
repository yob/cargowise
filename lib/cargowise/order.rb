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
    attr_reader :invoice_number

    attr_reader :buyer_name

    attr_reader :supplier_name

    attr_reader :shipments

    def initialize(node)
      @node = node

      @order_number = text_value("./OrderIdentifier/OrderNumber")
      @invoice_number = text_value("./OrderDetail/InvoiceNumber")
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

    def to_xml
      @node.to_xml
    end

  end

end
