# coding: utf-8

module Cargowise
  class Shipment < AbstractResult

    attr_reader :number, :housebill, :goods_description, :service_level

    attr_reader :shipper_name

    attr_reader :consignee_name

    def initialize(node)
      @node = node

      @number    = text_value("./Number")
      @housebill = text_value("./HouseBill")
      @goods_description = text_value("./GoodsDescription")
      @service_level = text_value("./ServiceLevel")

      @shipper_name = text_value("./Shipper/OrganisationDetails/Name")

      @consignee_name = text_value("./Consignee/OrganisationDetails/Name")
    end

  end
end
