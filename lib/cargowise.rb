# encoding: utf-8

# stdlib
require "bigdecimal"
require "handsoap"

# gems
require 'mechanize'
require 'andand'

module Cargowise
  DEFAULT_NS = "http://www.edi.com.au/EnterpriseService/"
  CA_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
end

# this lib
require 'cargowise/client'

# Make savon/httpi always use Net::HTTP for HTTP requests. It supports
# forcing the connection to TLSv1 (needed for OHL)
HTTPI.adapter = :net_http
