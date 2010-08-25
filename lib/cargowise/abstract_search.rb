# coding: utf-8

module Cargowise

  class AbstractSearch

    def initialize(endpoint)
      @endpoint = endpoint
    end

    private

    def ep
      @endpoint
    end

    def endpoint_hash
      {
        :uri => ep.uri,
        :version => 2
      }
    end

  end
end
