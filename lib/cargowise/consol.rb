# coding: utf-8

module Cargowise

  # Extra shipping detail associated with a Shipment. Not built
  # directly, but available via the consols() attribute
  # of the Shipment model.
  #
  class Consol < AbstractResult

    attr_reader :master_bill, :console_mode, :transport_mode
    attr_reader :vessel_name, :voyage_flight
    attr_reader :load_port, :discharge_port

    def initialize(node)
      @node = node

      @master         = text_value("./MasterBill")
      @console_mode   = text_value("./ConsolMode")
      @transport_mode = text_value("./TransportMode")
      @vessel_name    = text_value("./VesselName")
      @voyage_flight  = text_value("./VoyageFlight")
      @load_port      = text_value("./LoadPort")
      @discharge_port = text_value("./DischargePort")
    end
  end
end
