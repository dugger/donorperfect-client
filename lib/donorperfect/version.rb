module Donorperfect
  # Version for DonorPerfect API Client
  class Client
    # Version for DonorPerfect API Client
    class Version
      MAJOR = 0
      MINOR = 5
      PATCH = 2
      STRING = "#{MAJOR}.#{MINOR}.#{PATCH}".freeze

      class << self
        def inspect
          STRING
        end
        alias to_s inspect
      end
    end

    VERSION = Version::STRING
  end
end
