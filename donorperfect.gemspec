lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'donorperfect/version'

Gem::Specification.new do |spec|
  spec.name          = 'donorperfect'
  spec.version       = Donorperfect::Client::Version.to_s
  spec.authors       = ['Alex Dugger']
  spec.email         = ['alex@brightblue.dev']
  spec.description   = 'A Ruby client library for integrating with the DonorPerfect donor management API.'
  spec.homepage      = 'https://github.com/dugger/donorperfect-client'
  spec.summary       = 'Ruby client for DonorPerfect API - retrieve and update donor information.'
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.require_path  = 'lib'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'nokogiri', '~> 1.18'
  spec.add_dependency 'rest-client', '~> 2.1'
  spec.add_development_dependency 'irb'
  spec.add_development_dependency 'rdoc'
end
