# coding: utf-8

module Cargowise

  # SOAP client for retreiving order data. Not much to
  # see here, used by the Order resource class.
  #
  class OrdersClient

    # return an array of orders. Each order *should* correspond to a buyer PO.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_order_list(endpoint_uri, company_code, username, pass, filter_hash)
      client = build_client(endpoint_uri, company_code, username, pass)
      response = client.call(:get_order_list, message: filter_hash)
      response.xpath("//tns:GetOrderListResult/tns:WebOrder", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Order.new(node)
      end
    end

    private

    def wsdl_path
      File.join(
        File.dirname(__FILE__),
        "order_wsdl.xml"
      )
    end

    def build_client(endpoint_uri, company_code, username, password)
      Savon.client(
        wsdl: wsdl_path,
        endpoint: endpoint_uri,

        # Cargowise servers can be super slow to respond, this gives them time
        # to have a smoko before responding to our queries.
        read_timeout: 120,

        # OHL uses cargowise and has a load balancer that freaks out if we use
        # the OpenSSL 1.0.1 default of TLS1.1.
        ssl_version: :TLSv1,

        # savon 2.2.0 ignores the above ssl_version unless this is set to
        # false. Annoying.
        ssl_verify_mode: :none,

        # turn off logging to keep me sane. Change this to true when developing
        log: true,

        # the cargowsie API requires auth details in the SOAP header of every
        # request
        soap_header: {
          "tns:WebTrackerSOAPHeader" => {
            "tns:CompanyCode" => company_code,
            "tns:UserName" => username,
            "tns:Password" => password
          }
        }
      )
    end
  end
end
