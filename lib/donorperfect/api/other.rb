module Donorperfect
  class Other < DonorPerfectObject
    attr_accessor(
      :other_id,
      :donor_id,
      :other_date,
      :comments,
      :created_by,
      :created_date,
      :modified_by,
      :modified_date,
      :import_id,
      :wl_import_id
    )

    def initialize(options = {})
      # Create dynamic attr_accessors for other udf fields if client is available
      if options[:client] && options[:client].other_udf_field_names
        other_udf_field_names = options[:client].other_udf_field_names.map(&:to_sym)

        other_udf_field_names.each do |field_name|
          self.class.attr_accessor(field_name) unless respond_to?("#{field_name}=")
        end
      end

      super(options)
    end

    def update_dp
      params = UPDATE_OTHER_KEYS.map { |param| ['@' + param, ((send(param).nil? || send(param)&.to_s.empty?) ? nil : send(param))] }.to_h
      params.merge!({ '@user_id' => client.name })
      action = 'dp_saveotherinfo'
      response = client.connector.get(action, params).xpath('//field')&.first&.attribute('value')&.value
      return true if response == '0'

      if response&.to_i&.positive?
        self.other_id = response
        return true
      else
        return false
      end
    end

    def update_udf(udf_key, udf_type, value)
      if value.nil? || value.to_s.empty?
        action = "update dpotherinfoudf set #{udf_key} = null where other_id = #{other_id}"
        params = {}
        response = client.connector.get(action, params)
        # This response will not return a field if the update was successful
        return response.xpath('//field').empty?
      else
        action = 'dp_save_udf_xml'
        params = UPDATE_UDF_KEYS.map { |param| ['@' + param, nil] }.to_h
        params['@matching_id'] = other_id
        params['@field_name'] = udf_key
        params['@data_type'] = udf_type # C- Character, D-Date, N- numeric
        params['@char_value'] = value if udf_type == 'C'
        params['@date_value'] = value if udf_type == 'D'
        params['@number_value'] = value if udf_type == 'N'
        params['@user_id'] = client.name
        response = client.connector.get(action, params)
        return response.xpath('//field')&.first&.attribute('value')&.value == other_id
      end
    end

    UPDATE_OTHER_KEYS = %w[
      other_id
      donor_id
      other_date
      comments
    ].freeze

    UPDATE_UDF_KEYS = %w[
      matching_id
      field_name
      data_type
      char_value
      date_value
      number_value
    ].freeze
  end
end
