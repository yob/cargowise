# coding: utf-8

module Cargowise

  # SOAP client for retreiving shipment data. Not much to
  # see here, used by the Shipment resource class.
  #
  class ShipmentsClient < AbstractClient

    # return an array of shipments. Each shipment should correspond to
    # a consolidated shipment from the freight company.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_shipments_list(endpoint_uri, company_code, username, pass, filter_hash)
      client = build_client(shipment_wsdl_path, endpoint_uri, company_code, username, pass)
      response = client.call(:get_shipments_list, message: filter_hash)
      response.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Shipment.new(node)
      end
    end

    private

    def shipment_wsdl_path
      File.join(
        File.dirname(__FILE__),
        "shipment_wsdl.xml"
      )
    end

  end
end
