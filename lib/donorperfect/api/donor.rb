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
      :donor_rcpt_type,
      :retired,
      :spfname,
      :splname,
      :birthdate,
      :citizenship,
      :gender,
      :primary_contact,
      :kinection_id,
      :last_served_lead,
      :on_the_level,
      :biweek_update,
      :skill_flooring,
      :skill_framing,
      :skill_masonry,
      :skill_plumbing,
      :skill_roofing,
      :skill_drywall_finish,
      :skill_hvac,
      :skill_drywall_hang,
      :skill_painting,
      :skill_electrical,
      :emergency_contact,
      :em_contact_relat,
      :em_contact_phone,
      :em_contact_2phone,
      :bthindirect,
      :nobth,
      :bth_pref
    )

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
