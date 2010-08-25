# coding: utf-8

module Cargowise

  class OrderSearch < AbstractSearch

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
      OrdersClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      OrdersClient.get_order_list(ep.code, ep.user, ep.password, filter_hash)
    end

    # find all orders still marked as incomplete.
    #
    def incomplete
      filter_hash = {
        "tns:Filter" => { "tns:OrderStatus" => "INC" }
        }
      OrdersClient.endpoint(endpoint_hash) # probably not threadsafe. oops.
      OrdersClient.get_order_list(ep.code, ep.user, ep.password, filter_hash)
    end

  end
end

