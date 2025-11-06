# DonorPerfect Client

A Ruby client library for integrating with the DonorPerfect fundraising and donor management API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'donorperfect'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install donorperfect

## Usage

### Initialize the Client

#### Basic Client (DP fields only)

```ruby
require 'donorperfect'

@client = Donorperfect::Client.new("your_api_key", "client_name")
```

#### Extended Client (with custom DPUDF fields)

You can specify additional DPUDF (DonorPerfect User Defined Fields) to include when fetching donor data:

```ruby
# Specify which DPUDF fields you want to include (without 'dpudf.' prefix)
dpudf_fields = [
  'external_id',
  'lead', 
  'emergency_contact'
]

@client = Donorperfect::Client.new("your_api_key", "client_name", dpudf_fields)
```

**Note:** DPUDF field names cannot overlap with standard DP field names (like `donor_id`, `email`, `first_name`, etc.). An `ArgumentError` will be raised if there are conflicts.

### Get a Single Donor

```ruby
donor = @client.get_donor(donor_id)
puts "#{donor.first_name} #{donor.last_name} - #{donor.email}"

# If you initialized the client with DPUDF fields, you can access them directly:
# puts "Lead: #{donor.lead}"
# puts "External ID: #{donor.externa`_id}"
```

### Get Multiple Donors

```ruby
donors = @client.get_donors([123, 456, 789])
donors.each do |donor|
  puts "#{donor.first_name} #{donor.last_name}"
end
```

### Update Donor Information

```ruby
donor = @client.get_donor(donor_id)
donor.narrative = "Updated information"
success = donor.update_dp
```

## Field Availability

### Standard DP Fields (Always Available)

The following standard DonorPerfect fields are always available on donor objects:

- `donor_id`, `email`, `first_name`, `middle_name`, `last_name`
- `address`, `address2`, `city`, `state`, `country`, `zip`
- `mobile_phone`, `home_phone`, `business_phone`, `fax_phone`
- `narrative`, `suffix`, `title`, `salutation`, `prof_title`, `opt_line`
- `address_type`, `org_rec`, `donor_type`, `nomail`, `nomail_reason`, `donor_rcpt_type`

### DPUDF Fields (Configurable)

DPUDF (User Defined Fields) are only available if you specify them when creating the client. These fields are dynamically added as attributes to donor objects based on your configuration.

**Example DPUDF fields you might configure:**
- `lead`, `emergency_contact`, `dietary_needs`
- Custom fields specific to your DonorPerfect setup

## API Key

You'll need a DonorPerfect API key to use this gem. Contact DonorPerfect support to obtain your API credentials.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Version History

[See the change log](CHANGELOG.md)
