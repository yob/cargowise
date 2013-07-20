# coding: utf-8

require 'cargowise/abstract_result'
require 'cargowise/packing'
require 'cargowise/consol'
require 'cargowise/document'
require 'cargowise/invoice'

module Cargowise

  # A shipment that is currently on its way to you. Could take on a
  # variety of forms - carton, palet, truck? Could be travelling via
  # air, sea, road, rail, donkey?
  #
  # Typcially you will lookup the status of a shipment you're aware of
  # using the shipment number:
  #
  #     Shipment.find_by_shipment_number(...)
  #
  # If you want all recent shipments (delivered and undelivered) to
  # ensure you know what's coming:
  #
  #     Shipment.find_with_recent_activity(...)
  #
  # All shipment objects are read-only, see the object attributes to see
  # what information is available.
  #
  class Shipment < AbstractResult

    attr_reader :number, :housebill, :goods_description, :service_level
    attr_reader :client_reference
    attr_reader :origin, :destination, :etd, :eta, :delivered_date
    attr_reader :kg, :cubic_meters

    attr_reader :shipper_name

    attr_reader :consignee_name

    attr_reader :consols, :packings, :documents, :invoices

    def initialize(node)
      @node = node

      @number    = text_value("./Number")
      @housebill = text_value("./HouseBill")
      @goods_description = text_value("./GoodsDescription")
      @service_level = text_value("./ServiceLevel")
      @client_reference = text_value("./ClientReference")
      @origin        = text_value("./Origin")
      @destination   = text_value("./Destination")
      @etd           = time_value("./ETD")
      @eta           = time_value("./ETA")
      @delivered_date = time_value("./DeliveredDate")
      @kg            = kg_value("./Weight")
      @cubic_meters  = cubic_value("./Size")

      @shipper_name = text_value("./Shipper/OrganisationDetails/Name")

      @consignee_name = text_value("./Consignee/OrganisationDetails/Name")

      @consols = node_array("./Consols/Consol").map { |node|
        Consol.new(node)
      }

      @packings = node_array("./Packings/Packing").map { |node|
        Packing.new(node)
      }

      @documents = node_array("./DocumentLinks/DocumentLink").map { |node|
        Document.new(node)
      }.sort_by { |doc|
        doc.date
      }

      @invoices = node_array("./RelatedInvoiceLinks/InvoiceLink").map { |node|
        Invoice.new(node)
      }.sort_by { |inv|
        inv.due_date
      }
    end

    # returns the raw XML string this shipment is based on
    #
    def to_xml
      @node.to_xml
    end

    # returns a space separated string with all transport modes being used
    # to move this shipment
    #
    def transport_mode
      @consols.map { |con| con.transport_mode }.uniq.sort.join(" ")
    end

    # lookup full Cargowise::Order objects for each order on this shipment.
    #
    # client is a Cargowise::Client instance to look for the related shipments on
    #
    def orders(client)
      @orders ||= client.orders.by_shipment_number(self.number)
    end

    # lookup related Cargowise::Shipment objects. These are usually "child" shipments
    # grouped under a parent. Think a consolidated pallet (the parent) with cartons from
    # multiple suppliers (the children).
    #
    # client is a Cargowise::Client instance to look for the related shipments on
    #
    def related_shipments(client)
      @related ||= @consols.map { |consol|
        consol.master_bill
      }.compact.map { |master_bill|
        client.shipments.by_masterbill_number(master_bill)
      }.flatten.select { |shipment|
        shipment.number != self.number
      }.compact
    end

    # if this shipment has an order ref associated with it, find it.
    #
    # This data isn't available via the API, so we need to screen scrape the
    # website to get it.
    #
    # client is a Cargowise::Client instance to look for the related shipments on
    #
    def order_ref(client)
      if client.base_uri
        @order_ref ||= html_page(client).search(".//span[@id='Ztextlabel1']/text()").to_s.strip || ""
      else
        nil
      end
    end

    private

    # retrieve a Mechanize::Page object that containts info on this shipment
    #
    def html_page(client)
      return nil unless client.base_uri

      @html_page ||= begin
        login_uri = client.base_uri + "/Login/Login.aspx"
        agent = Mechanize.new
        agent.agent.http.ssl_version = :TLSv1
        if File.file?(Cargowise::CA_CERT_FILE)
          agent.agent.http.ca_file = CA_CERT_FILE
        end
        page  = agent.get(login_uri)
        form  = page.forms.first
        input_name = form.fields.detect { |field| field.name.to_s.downcase.include?("number")}.andand.name
        form.__send__("#{input_name}=", self.number) if input_name
        form.add_field!("ViewShipmentBtn","View Shipment")
        agent.submit(form)
      end
    end

  end
end
