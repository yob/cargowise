# coding: utf-8

module Cargowise

  # SOAP client for retreiving order data. Not much to
  # see here, used by the Order resource class.
  #
  class OrdersClient < AbstractClient # :nodoc:

    # return an array of orders. Each order *should* correspond to a buyer PO.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_order_list(company_code, username, pass, filter_hash)
      soap_action  = 'http://www.edi.com.au/EnterpriseService/GetOrderList'
      soap_headers = headers(company_code, username, pass)
      response = invoke('tns:GetOrderList', :soap_action => soap_action, :soap_header => soap_headers, :soap_body => filter_hash, :http_options => cwkhttp_options)
      response.document.xpath("//tns:GetOrderListResult/tns:WebOrder", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Order.new(node)
      end
    end
  end
end
