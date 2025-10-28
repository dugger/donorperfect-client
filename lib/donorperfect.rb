require_relative 'donorperfect/connector'
require_relative 'donorperfect/version'
require_relative 'donorperfect/api/donor_perfect_object'
require_relative 'donorperfect/api/donor'
require_relative 'donorperfect/api/other'
require_relative 'donorperfect/api/code'
require 'rest-client'
require 'nokogiri'

module Donorperfect
  # Client class for DonorPerfect API
  class Client
    alias_method :inspect_original, :inspect if ! self.method_defined?(:inspect_original)
    attr_accessor(:connector, :name, :dpudf_fields, :other_udf_fields)

    def initialize(apikey, name, dpudf_fields = [], other_udf_fields = [])
      @connector = Donorperfect::Connector.new(apikey, dpudf_fields, other_udf_fields)
      @name = name || 'API_Client'
      @dpudf_fields = dpudf_fields
      @other_udf_fields = other_udf_fields
    end

    def dpudf_field_names
      @connector.dpudf_field_names
    end

    def other_udf_field_names
      @connector.other_udf_field_names
    end

    def get_donor(donor_id)
      result = @connector.get_donor(donor_id)
      return nil if result.nil?

      create_object(Donorperfect::Donor, result)
    end

    def get_donors_by_email(email)
      results = @connector.get_donors_by_email(email)
      create_objects(Donorperfect::Donor, results)
    end

    def get_donors(donor_ids = [])
      results = @connector.get_donors(donor_ids)
      create_objects(Donorperfect::Donor, results)
    end

    def get_all_donors(filters = [], page = nil)
      results = @connector.get_all_donors(filters, page)
      create_objects(Donorperfect::Donor, results)
    end

    def get_codes(field_name)
      results = @connector.get_codes(field_name)
      create_objects(Donorperfect::Code, results)
    end

    def get_code(code, field_name)
      result = @connector.get_code(code, field_name)
      create_object(Donorperfect::Code, result)
    end

    def get_other(other_id)
      result = @connector.get_other(other_id)
      create_object(Donorperfect::Other, result)
    end

    def inspect
      # Create a string of attributes to display, excluding the ones you want to hide
      attributes_to_display = (instance_variables - [:@connector, :@other_udf_fields, :@dpudf_fields]).map do |key|
        "#{key}: #{instance_variable_get(key).inspect}" # Use inspect for attribute values for proper representation
      end.join(", ")

      # Combine the default inspect and your custom attributes
      "#<#{self.class.name}:0x#{object_id.to_s(16).rjust(16, '0')} #{attributes_to_display}>"
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
