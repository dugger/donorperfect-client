module Donorperfect
  require 'json'
  # Connector class for DonorPerfect API
  class Connector
    attr_accessor(:apikey, :web_services_url, :dpudf_fields)
    attr_reader(:dpudf_field_names)

    DEFAULT_DP_FIELDS = [
      'dp.donor_id',
      'dp.email',
      'dp.first_name',
      'dp.middle_name',
      'dp.last_name',
      'dp.address',
      'dp.address2',
      'dp.city',
      'dp.state',
      'dp.country',
      'dp.zip',
      'dp.no_email',
      'dp.mobile_phone',
      'dp.home_phone',
      'dp.business_phone',
      'dp.fax_phone',
      'dp.narrative',
      'dp.suffix',
      'dp.title',
      'dp.salutation',
      'dp.prof_title',
      'dp.opt_line',
      'dp.address_type',
      'dp.org_rec',
      'dp.donor_type',
      'dp.nomail',
      'dp.nomail_reason',
      'dp.donor_rcpt_type'
    ].freeze

    def initialize(apikey, dpudf_fields = [])
      @web_services_url = 'https://www.donorperfect.net/prod/xmlrequest.asp'
      @apikey = apikey

      # Validate that dpudf fields don't overlap with dp fields
      validate_field_names(dpudf_fields)

      @dpudf_field_names = dpudf_fields
      @dpudf_fields = dpudf_fields.map { |field| "dpudf.#{field}" }
    end

    def donor_fields
      DEFAULT_DP_FIELDS + @dpudf_fields
    end

    def get(action, params = {})
      url = construct_url(action, params)
      response = RestClient.get(url.to_s)

      Nokogiri::XML(response)
    end

    def construct_url(action, params = {})
      url = URI(@web_services_url)
      url.query = "apikey=#{@apikey}"
      url.query += "&#{URI.encode_www_form({ action: action })}"
      unless params.empty?
        first = true
        url.query += '&params='
        params.each do |k, v|
          v = "'#{v}'" if v != 'null'
          url.query += "#{',' unless first}#{URI.encode_www_form({ k => v })}"
          first = false
        end
      end
      url
    end

    def get_donor(donor_id)
      query = "select #{donor_fields.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id where dp.donor_id = #{donor_id}"
      response = get(query)
      return nil if response.xpath('//record').empty?

      record_to_hash(response.xpath('//record').first)
    end

    def get_donors(donor_ids = [])
      query = "select top 100 #{donor_fields.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id where dp.donor_id in (#{donor_ids.join(',')})"
      response = get(query)
      return [] if response.xpath('//record').empty?

      response.xpath('//record').map { |record| record_to_hash(record) }
    end

    def get_all_donors(filters = [], page = nil)
      base_query = "select #{donor_fields.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id"
      base_query += " where #{filters.join(' and ')}" if filters.any?

      if page.nil?
        # No pagination - return all results (up to API limit)
        response = get(base_query)
      else
        # Paginated query
        page = 0 if page < 0  # Ensure page is not negative
        batch_size = 500
        offset = page * batch_size

        query = base_query + " order by dp.donor_id offset #{offset} rows fetch next #{batch_size} rows only"
        response = get(query)
      end

      return [] if response.xpath('//record').empty?

      response.xpath('//record').map { |record| record_to_hash(record) }
    end

    def get_codes(field_name)
      query = "select * from dpcodes where field_name = '#{field_name}'"
      response = get(query)
      return [] if response.xpath('//record').empty?

      response.xpath('//record').map { |record| record_to_hash(record) }
    end

    def get_code(code, field_name)
      query = "select * from dpcodes where code = '#{code}' and field_name = '#{field_name}'"
      response = get(query)
      return nil if response.xpath('//record').empty?

      record_to_hash(response.xpath('//record').first)
    end

    def record_to_hash(record)
      hash = {}
      record.xpath('field').each do |field|
        field_name = field.attribute('name')&.value
        field_value = field.attribute('value')&.value
        hash[field_name] = field_value if field_name
      end
      hash
    end

    private

    def validate_field_names(dpudf_fields)
      # Extract field names from DEFAULT_DP_FIELDS (remove 'dp.' prefix)
      dp_field_names = DEFAULT_DP_FIELDS.map { |field| field.gsub('dp.', '') }

      # Check for overlapping field names
      overlapping_fields = dpudf_fields & dp_field_names

      unless overlapping_fields.empty?
        raise ArgumentError, "DPUDF fields cannot overlap with DP fields. Conflicting fields: #{overlapping_fields.join(', ')}"
      end
    end
  end
end
