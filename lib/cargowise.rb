# encoding: utf-8

# stdlib
require "bigdecimal"
require "handsoap"

module Cargowise
  DEFAULT_NS = "http://www.edi.com.au/EnterpriseService/"
end

# this lib
require 'cargowise/abstract_client'
require 'cargowise/orders_client'
require 'cargowise/shipments_client'
require 'cargowise/abstract_result'
require 'cargowise/order'
require 'cargowise/shipment'
require 'cargowise/document'
require 'cargowise/invoice'
require 'cargowise/endpoint'
require 'cargowise/abstract_search'
require 'cargowise/order_search'
require 'cargowise/shipment_search'
