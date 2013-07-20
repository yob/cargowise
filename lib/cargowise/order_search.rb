# coding: utf-8

require 'cargowise/order'

module Cargowise

  class OrderSearch

    def initialize(savon_client)
      @savon_client = savon_client
    end

    # find all orders with an OrderNumber that matches ref
    #
    def by_order_number(ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => "OrderNumber",
            "tns:NumberValue" => ref
          }
        }
      }
      get_order_list(filter_hash)
    end

    # find all orders with a ShipmentNumber that matches ref
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
      get_order_list(filter_hash)
    end

    # find all orders still marked as incomplete.
    #
    def incomplete
      filter_hash = {
        "tns:Filter" => { "tns:OrderStatus" => "INC" }
        }
      get_order_list(filter_hash)
    end

    private

    # return an array of orders. Each order *should* correspond to a buyer PO.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_order_list(filter_hash)
      response = @savon_client.call(:get_order_list, message: filter_hash)
      response.xpath("//tns:GetOrderListResult/tns:WebOrder", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Order.new(node)
      end
    end

  end
end

