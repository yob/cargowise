# coding: utf-8

module Cargowise

  # SOAP client for retreiving order data. Not much to
  # see here, used by the Order resource class.
  #
  class OrdersClient < AbstractClient

    # return an array of orders. Each order *should* correspond to a buyer PO.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_order_list(endpoint_uri, company_code, username, pass, filter_hash)
      client = build_client(order_wsdl_path, endpoint_uri, company_code, username, pass)
      response = client.call(:get_order_list, message: filter_hash)
      response.xpath("//tns:GetOrderListResult/tns:WebOrder", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Order.new(node)
      end
    end

    # test authentication, returns a string with your company name
    # if successful
    #
    def hello(endpoint_uri, company_code, username, pass)
      client = build_client(order_wsdl_path, endpoint_uri, company_code, username, pass)
      response = client.call(:hello)
      response.xpath("//tns:HelloResponse/tns:HelloResult/text()", {"tns" => Cargowise::DEFAULT_NS}).to_s
    end

    private

    def order_wsdl_path
      File.join(
        File.dirname(__FILE__),
        "order_wsdl.xml"
      )
    end

  end
end
