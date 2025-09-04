module Donorperfect
  class Donor < DonorPerfectObject
    attr_accessor(
      :donor_id,
      :email,
      :first_name,
      :middle_name,
      :last_name,
      :address,
      :address2,
      :city,
      :state,
      :country,
      :zip,
      :no_email,
      :mobile_phone,
      :home_phone,
      :business_phone,
      :fax_phone,
      :narrative,
      :suffix,
      :title,
      :salutation,
      :prof_title,
      :opt_line,
      :address_type,
      :org_rec,
      :donor_type,
      :nomail,
      :nomail_reason,
      :donor_rcpt_type
    )

    def initialize(options)
      # Create dynamic attr_accessors for dpudf fields if client is available
      if options[:client] && options[:client].dpudf_field_names
        dpudf_field_names = options[:client].dpudf_field_names.map(&:to_sym)

        dpudf_field_names.each do |field_name|
          self.class.attr_accessor(field_name) unless respond_to?("#{field_name}=")
        end
      end

      super(options)
    end

    def update_dp
      params = UPDATE_DONOR_KEYS.map { |param| ['@' + param, send(param)] }.to_h
      params.merge!({ '@user_id' => client.name })
      action = 'dp_savedonor'
      response = client.connector.get(action, params)
      response.xpath('//field')&.first&.attribute('value')&.value == '0'
    end

    def update_udf(udf_key, udf_type, value)
      action = 'dp_save_udf_xml'

      params = UPDATE_DONOR_UDF_KEYS.map { |param| ['@' + param, 'null'] }.to_h

      params['@matching_id'] = donor_id
      params['@field_name'] = udf_key
      params['@data_type'] = udf_type # C- Character, D-Date, N- numeric
      params['@char_value'] = value if udf_type == 'C'
      params['@date_value'] = value if udf_type == 'D'
      params['@number_value'] = value if udf_type == 'N'
      params['@user_id'] = client.name

      response = client.connector.get(action, params)
      response.xpath('//field')&.first&.attribute('value')&.value == donor_id
    end

    UPDATE_DONOR_KEYS = %w[
      donor_id
      first_name
      last_name
      middle_name
      suffix
      title
      salutation
      prof_title
      opt_line
      address
      address2
      city
      state
      zip
      country
      address_type
      home_phone
      business_phone
      fax_phone
      mobile_phone
      email
      org_rec
      donor_type
      nomail
      nomail_reason
      narrative
      donor_rcpt_type
    ].freeze

    UPDATE_DONOR_UDF_KEYS = %w[
      matching_id
      field_name
      data_type
      char_value
      date_value
      number_value
    ].freeze
  end
end
