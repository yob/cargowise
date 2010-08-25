# coding: utf-8

module Cargowise

  # Stores the details for connecting to a single logistics company.
  #
  # Generally created using the register() method on the Order and
  # Shipment classes.
  #
  class Endpoint

    attr_reader :uri
    attr_reader :code, :user, :password

    # create a new endpoint. All 4 options are compulsory.
    #
    def initialize(opts = {})
      raise ArgumentError, "option :uri must be provided"      if opts[:uri].nil?
      raise ArgumentError, "option :code must be provided"     if opts[:code].nil?
      raise ArgumentError, "option :user must be provided"     if opts[:user].nil?
      raise ArgumentError, "option :password must be provided" if opts[:password].nil?

      @uri = opts[:uri]
      @code, @user, @password = opts[:code], opts[:user], opts[:password]
    end
  end
end
