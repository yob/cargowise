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
    def get_shipments_list(company_code, username, pass, filter_hash)
      response = client.call(:get_shipments_list, message: filter_hash)
      response.document.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
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

    def client(company_code, username, password)
      Savon.client(
        wsdl: wsdl_path,
        endpoint: "https://webtracking.ohl.com/WebService/ShipmentService.asmx",

        read_timeout: 120,
        ssl_version: :TLSv1,
        ssl_verify_mode: :none,

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
