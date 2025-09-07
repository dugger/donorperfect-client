module Donorperfect
  class Code < DonorPerfectObject
    attr_accessor(
      :code_id, :code, :description, :field_name, :mcat_hi, :mcat_lo, :mcat_gl, :reciprocal, :code_date, :mailed, :printing, :other, :acct_num,
      :holes, :pccash, :campaign, :cashact, :played, :pledge_credit, :pledge_debit, :goal, :tysdp, :tysdpgift, :tyandor, :inactive, :created_by,
      :created_date, :modified_by, :modified_date, :solicit_type, :available_for_sol, :primary_source, :client_id, :costformedia,
      :membership_type, :leeway_days, :comments, :fiscal_month, :currency_symbol, :non_gift, :direction, :country, :other_description,
      :start_date, :end_date, :mcat_code, :mcat_months, :ty_prioritize, :ty_filter_id, :ty_gift_option, :ty_amount_option, :ty_from_amount,
      :ty_to_amount, :ty_alternate, :ty_priority, :import_id, :ty_email_tmplt_id, :solicit_code2, :code_grouping
    )

    # UPDATE_DONOR_KEYS = %w[
    #   field_name code description original_code code_date mcat_hi mcat_lo mcat_gl acct_num campaign solicit_code overwrite inactive client_id 
    #   available_for_sol user_id cashact membership_type leeway_days comments  begin_date end_date ty_prioritize ty_filter_id ty_gift_option 
    #   ty_amount_option ty_from_amount ty_to_amount ty_alternate ty_priority
    # ].freeze
  end
end
