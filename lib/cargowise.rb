# encoding: utf-8

# stdlib
require "bigdecimal"
require "handsoap"

# gems
require 'mechanize'
require 'andand'
require 'savon'

module Cargowise
  DEFAULT_NS = "http://www.edi.com.au/EnterpriseService/"
  CA_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
end

# this lib
require 'cargowise/client'
require 'cargowise/abstract_result'
require 'cargowise/order'
require 'cargowise/shipment'
require 'cargowise/packing'
require 'cargowise/consol'
require 'cargowise/document'
require 'cargowise/invoice'
require 'cargowise/endpoint'
require 'cargowise/order_search'
require 'cargowise/shipment_search'

# Make savon/httpi always use Net::HTTP for HTTP requests. It supports
# forcing the connection to TLSv1 (needed for OHL)
HTTPI.adapter = :net_http
