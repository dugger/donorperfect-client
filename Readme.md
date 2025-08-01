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

```ruby
require 'donorperfect'

@client = Donorperfect::Client.new("your_api_key", "client_name")
```

### Get a Single Donor

```ruby
donor = @client.get_donor(donor_id)
puts "#{donor.first_name} #{donor.last_name} - #{donor.email}"
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

## API Key

You'll need a DonorPerfect API key to use this gem. Contact DonorPerfect support to obtain your API credentials.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Version History

[See the change log](CHANGELOG.md)
