# coding: utf-8

module Cargowise
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
    end
  end

end
