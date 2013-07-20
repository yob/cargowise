# coding: utf-8

module Cargowise

  # SOAP client for retreiving shipment data. Not much to
  # see here, used by the Shipment resource class.
  #
  class ShipmentsClient # < AbstractClient # :nodoc:

    # return an array of shipments. Each shipment should correspond to
    # a consolidated shipment from the freight company.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_shipments_list(endpoint_uri, company_code, username, pass, filter_hash)
      client = build_client(endpoint_uri, company_code, username, pass)
      response = client.call(:get_shipments_list, message: filter_hash)
      response.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Shipment.new(node)
      end
    end

    private

    def wsdl_path
      File.join(
        File.dirname(__FILE__),
        "shipment_wsdl.xml"
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
        log: false,

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
