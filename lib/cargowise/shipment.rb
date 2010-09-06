# coding: utf-8

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
    attr_reader :origin, :destination, :etd, :eta, :delivered_date

    attr_reader :shipper_name

    attr_reader :consignee_name

    attr_reader :consols, :documents, :invoices

    def initialize(node)
      @node = node

      @number    = text_value("./Number")
      @housebill = text_value("./HouseBill")
      @goods_description = text_value("./GoodsDescription")
      @service_level = text_value("./ServiceLevel")
      @origin        = text_value("./Origin")
      @destination   = text_value("./Destination")
      @etd           = time_value("./ETD")
      @eta           = time_value("./ETA")
      @delivered_date = time_value("./DeliveredDate")

      @shipper_name = text_value("./Shipper/OrganisationDetails/Name")

      @consignee_name = text_value("./Consignee/OrganisationDetails/Name")

      @consols = node_array("./Consols/Consol").map { |node|
        Consol.new(node)
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
    # 'via' is a symbol indicating which API endpoint to lookup.
    #
    def orders(via)
      @orders ||= Cargowise::Order.via(via).by_shipment_number(self.number)
    end

    # lookup related Cargowise::Shipment objects. These are usually "child" shipments
    # grouped under a parent. Think a consolidated pallet (the parent) with cartons from
    # multiple suppliers (the children).
    #
    # 'via' is a symbol indicating which API endpoint to lookup.
    #
    def related_shipments(via)
      @related ||= @consols.map { |consol|
        consol.master_bill
      }.compact.map { |master_bill|
        Cargowise::Shipment.via(via).by_masterbill_number(master_bill)
      }.flatten.select { |shipment|
        shipment.number != self.number
      }.compact
    end

    # if this shipment has an order ref associated with it, find it.
    #
    # This data isn't available via the API, so we need to screen scrape the
    # website to get it.
    #
    def order_ref(via)
      content = html_page(via)
      #content[/word-wrap:break-word;">(.+)<\/span>/,1]
    end

    private

    def html_page(via)
      @html_page ||= begin
        document = self.documents.first
        document ||= related_shipments(via).detect { |ship|
          ship.documents.size > 0
        }.documents.first
        base_uri = document.link[/(.+)AutoLoginRequest.+/,1]
        login_uri = base_uri + "Login/Login.aspx"
        client = HTTPClient.new
        client.get(login_uri)
        response = client.post(login_uri, :QuickViewNumber => self.number, :ViewShipmentBtn => "View")
        shipment_uri = base_uri + response.header['Location'].to_s
        response = client.get(shipment_uri)
        response.content
      end
    end

  end
end
