# coding: utf-8

module Cargowise

  # Superclass of all clients, currently we have clients for
  # orders and Shipments.
  #
  # Not much to see here, just common methods
  #
  class AbstractClient < Handsoap::Service # :nodoc:
    def on_create_document(doc)
      doc.alias 'tns', Cargowise::DEFAULT_NS
    end

    def on_response_document(doc)
      doc.add_namespace 'ns', Cargowise::DEFAULT_NS
    end

    # test authentication, returns a string with your company name
    # if successful
    #
    def hello(company_code, username, pass)
      soap_action  = 'http://www.edi.com.au/EnterpriseService/Hello'
      soap_headers = headers(company_code, username, pass)
      response     = invoke('tns:Hello', :soap_action => soap_action, :soap_header => soap_headers, :http_options => cw_http_options)
      response.document.xpath("//tns:HelloResponse/tns:HelloResult/text()", {"tns" => Cargowise::DEFAULT_NS}).to_s
    end

    private

    def cw_http_options
      if File.file?(Cargowise::CA_CERT_FILE)
        {:trust_ca_file => Cargowise::CA_CERT_FILE}
      else
        {}
      end
    end

    def headers(company_code, username, pass)
      {
        "tns:WebTrackerSOAPHeader" => {
          "tns:CompanyCode" => company_code,
          "tns:UserName"    => username,
          "tns:Password"    => pass
        }
      }
    end

  end
end
