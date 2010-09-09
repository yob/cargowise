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
    attr_reader :client_reference
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
      @client_reference = text_value("./ClientReference")
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
      if tracker_login_uri(via)
        @order_ref ||= html_page(via).search(".//span[@id='Ztextlabel1']/text()").to_s.strip || ""
      else
        nil
      end
    end

    private

    # retrieve a Mechanize::Page object that containts info on this shipment
    #
    def html_page(via)
      return nil unless tracker_login_uri(via)

      @html_page ||= begin
        base_uri = tracker_login_uri(via)
        login_uri = base_uri + "/Login/Login.aspx"
        agent = Mechanize.new
        page  = agent.get(login_uri)
        form  = page.forms.first
        input_name = form.fields.detect { |field| field.name.to_s.downcase.include?("number")}.name
        form.__send__("#{input_name}=", self.number) if input_name
        form.add_field!("ViewShipmentBtn","View Shipment")
        agent.submit(form)
      end
    end

    # Find a shipment with documents attached so we can discover the
    # web interface uri
    #
    def tracker_login_uri(via)
      Shipment.endpoint(via).uri.to_s[/(.+)\/WebService.+/,1]
    end
  end
end
