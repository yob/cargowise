# coding: utf-8

module Cargowise

  # Superclass of all clients, currently we have clients for
  # orders and Shipments.
  #
  # Not much to see here, just common methods
  #
  class AbstractClient

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

    def build_client(wsdl_path, endpoint_uri, company_code, username, password)
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
