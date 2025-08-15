module Donorperfect
  require 'json'
  # Connector class for DonorPerfect API
  class Connector
    attr_accessor(:apikey, :web_services_url)

    DEFAULT_DONOR_FIELDS = [
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
      'dp.donor_rcpt_type',
      'dp.modified_by',
      'dpudf.retired',
      'dpudf.spfname',
      'dpudf.splname',
      'dpudf.birthdate',
      'dpudf.gender',
      'dpudf.citizenship',
      'dpudf.primary_contact',
      'dpudf.kinection_id',
      'dpudf.kin_modified_date',
      'dpudf.kin_last_logged',
      'dpudf.last_served_lead',
      'dpudf.on_the_level',
      'dpudf.biweek_update',
      'dpudf.skill_flooring',
      'dpudf.skill_framing',
      'dpudf.skill_masonry',
      'dpudf.skill_plumbing',
      'dpudf.skill_roofing',
      'dpudf.skill_drywall_finish',
      'dpudf.skill_hvac',
      'dpudf.skill_drywall_hang',
      'dpudf.skill_painting',
      'dpudf.skill_electrical',
      'dpudf.skill_cabinet_count',
      'dpudf.skill_finish_carpent',
      'dpudf.skill_handyman',
      'dpudf.skill_chainsaw',
      'dpudf.skill_skidsteer',
      'dpudf.emergency_contact',
      'dpudf.em_contact_relat',
      'dpudf.em_contact_phone',
      'dpudf.em_contact_2phone',
      'dpudf.bth',
      'dpudf.bthindirect',
      'dpudf.nobth',
      'dpudf.bth_pref'
    ].freeze

    def initialize(apikey)
      @web_services_url = 'https://www.donorperfect.net/prod/xmlrequest.asp'
      @apikey = apikey
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
      query = "select #{DEFAULT_DONOR_FIELDS.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id where dp.donor_id = #{donor_id}"
      response = get(query)
      return nil if response.xpath('//record').empty?

      record_to_hash(response.xpath('//record').first)
    end

    def get_donors(donor_ids = [])
      query = "select top 100 #{DEFAULT_DONOR_FIELDS.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id where dp.donor_id in (#{donor_ids.join(',')})"
      response = get(query)
      return [] if response.xpath('//record').empty?

      response.xpath('//record').map { |record| record_to_hash(record) }
    end

    def get_all_donors(filters = [], page = nil)
      base_query = "select #{DEFAULT_DONOR_FIELDS.join(',')} from dp join dpudf on dp.donor_id = dpudf.donor_id"
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

    # Examples:
    # get_all_donors() # Get first 500 donors (page 0)
    # get_all_donors([], 0) # Get first page (0-499)
    # get_all_donors([], 1) # Get second page (500-999)
    # get_all_donors(["dpudf.LAST_SERVED_DATE > '2020-01-01'", "dp.email is not null"], 0) # Filtered first page

    def record_to_hash(record)
      hash = {}
      record.xpath('field').each do |field|
        field_name = field.attribute('name')&.value
        field_value = field.attribute('value')&.value
        hash[field_name] = field_value if field_name
      end
      hash
    end
  end
end
