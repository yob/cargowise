HTTPI.adapter = :net_http

module Cargowise
  class Shipment
    extend Savon::Model

    client wsdl: File.dirname(__FILE__) + "/shipment_wsdl.xml", endpoint: "https://webtracking.ohl.com/WebService/ShipmentService.asmx"

    # required because OHLs server is unbelievably slow
    global :read_timeout, 120

    # required because SSLv2 (the default) combined with openssl 1.0.1 makes
    # a large SSL hello packet that OHLs server doesn't like
    global :ssl_version, :TLSv1

    # required due to a bug in Savon that means our ssl_version config
    # option is ignored unless we disable SSL peer verification
    global :ssl_verify_mode, :none
    #global :ssl_cert_file, "/etc/ssl/certs/ca-certificates.crt"

    # need to find a better place for this!
    global :soap_header, {
      "tns:WebTrackerSOAPHeader" => {
        "tns:CompanyCode" => "XXX",
        "tns:UserName" => "XXX@YYY.ZZZ",
        "tns:Password" => "PASSWORD"
      }
    }

    operations :hello, :get_shipments_list

    def find_by_shipment_number(number)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => "ShipmentNumber",
            "tns:NumberValue" => "SORD30059237"
          }
        }
      }
      get_shipments_list(message: filter_hash).body
    end

  end
end
