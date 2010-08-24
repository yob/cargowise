# coding: utf-8

module Cargowise

  # A document that is associated with a Shipment. Not built
  # directly, but available via the documents() attribute
  # of the Shipment model.
  #
  class Document < AbstractResult

    attr_reader :date, :description, :link

    def initialize(node)
      @node = node

      @date        = time_value("./Date")
      @description = text_value("./Description")
      @link        = text_value("./Link")
    end
  end
end
