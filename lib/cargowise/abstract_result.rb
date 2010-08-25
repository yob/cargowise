# coding: utf-8

module Cargowise

  # Superclass of all objects built to contain results from
  # the API. Not much to see here, mostly common helper methods
  # for parsing values out of the XML response.
  #
  class AbstractResult # :nodoc:

    def self.register(name, opts = {})
      @endpoints ||= {}
      @endpoints[name] = Endpoint.new(opts)
    end

    def self.via(name)
      @endpoints ||= {}
      raise ArgumentError, "#{name} is not recognised, have you registered it?" if @endpoints[name].nil?

      klass_name = (self.name[/Cargowise::(.+)/,1] + "Search")
      search_klass = Cargowise.const_get(klass_name)
      search_klass.new(@endpoints[name])
    end

    def inspect
      str = "<#{self.class}: "
      str << inspectable_vars.map { |v| "#{v.tr('@','')}: #{instance_variable_get(v)}" }.join(" ")
      str << ">"
      str
    end

    private

    def node
      @node
    end

    def inspectable_vars
      instance_variables.select { |var| var != "@node"}
    end

    def node_array(path)
      path = path.gsub("/","/tns:")
      node.xpath("#{path}", "tns" => Cargowise::DEFAULT_NS)
    end

    def text_value(path)
      path = path.gsub("/","/tns:")
      node.xpath("#{path}/text()", "tns" => Cargowise::DEFAULT_NS).to_s
    end

    def time_value(path)
      val = text_value(path)
      val.nil? ? nil : DateTime.parse(val)
    end

    def decimal_value(path)
      val = text_value(path)
      val.nil? ? nil : BigDecimal.new(val)
    end
  end
end
