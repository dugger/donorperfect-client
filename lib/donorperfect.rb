require_relative 'donorperfect/connector'
require_relative 'donorperfect/version'
require_relative 'donorperfect/api/donor_perfect_object'
require_relative 'donorperfect/api/donor'
require 'rest-client'
require 'nokogiri'

module Donorperfect
  # Client class for DonorPerfect API
  class Client
    attr_accessor(:connector, :name)

    def initialize(apikey, name)
      @connector = Donorperfect::Connector.new(apikey)
      @name = name || 'API_Client'
    end

    def get_donor(donor_id)
      result = @connector.get_donor(donor_id)
      create_object(Donorperfect::Donor, result)
    end

    def get_donors(donor_ids = [])
      results = @connector.get_donors(donor_ids)
      create_objects(Donorperfect::Donor, results)
    end

    private

    def create_object(klass, values)
      klass.new({ values: values, client: self })
    end

    def create_objects(klass, results)
      results = [results] if results.instance_of?(Hash)
      ret = results.collect do |result|
        create_object(klass, result)
      end
      ret || []
    end
  end
end
