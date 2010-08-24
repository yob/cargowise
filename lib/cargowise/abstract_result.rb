# coding: utf-8

module Cargowise
  class AbstractResult

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
