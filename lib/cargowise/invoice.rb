# coding: utf-8

require 'cargowise/abstract_result'

module Cargowise

  # An invoice that is associated with a Shipment. Not built
  # directly, but available via the invoices() attribute
  # of the Shipment model.
  #
  class Invoice < AbstractResult

    attr_reader :number, :issuer, :type, :date, :due_date
    attr_reader :currency, :total, :outstanding
    attr_reader :link

    def initialize(node)
      @node = node

      @number      = text_value("./InvoiceNumber")
      @issuer      = text_value("./IssuerName")
      @date        = time_value("./InvoiceDate")
      @due_date    = time_value("./DueDate")
      @currency    = text_value("./Currency")
      @total       = decimal_value("./TotalAmount")
      @outstanding = decimal_value("./OutstandingAmount")
      @link        = text_value("./Link")
    end
  end
end
