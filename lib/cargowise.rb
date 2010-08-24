# encoding: utf-8

require "bigdecimal"
require "handsoap"
require "andand"

module Cargowise
  ORDER_ENDPOINT = {
    :uri => 'http://visibility.ijsglobal.com/Tracker/WebService/OrderService.asmx',
    :version => 2
  }
  SHIPMENT_ENDPOINT = {
    :uri => 'http://visibility.ijsglobal.com/Tracker/WebService/ShipmentService.asmx',
    :version => 2
  }
  DEFAULT_NS = "http://www.edi.com.au/EnterpriseService/"
end

require 'cargowise/abstract_client'
require 'cargowise/orders_client'
require 'cargowise/shipments_client'
require 'cargowise/abstract_result'
require 'cargowise/order'
require 'cargowise/shipment'
