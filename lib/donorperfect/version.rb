module Donorperfect
  # Version for DonorPerfect API Client
  class Client
    # Version for DonorPerfect API Client
    class Version
      MAJOR = 0
      MINOR = 3
      PATCH = 0
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
