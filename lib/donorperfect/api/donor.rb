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
      :primary_contact
    )

    def update_dp
      params = UPDATE_DONOR_KEYS.map { |param| ['@' + param, send(param)] }.to_h
      params.merge!({ '@user_id' => client.name })
      action = 'dp_savedonor'
      response = client.connector.get(action, params)
      response.xpath('//field')&.first&.attribute('value')&.value == '0'
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
  end
end
