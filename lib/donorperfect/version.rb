module Donorperfect
  # Version for DonorPerfect API Client
  class Client
    # Version for DonorPerfect API Client
    class Version
      MAJOR = 0
      MINOR = 4
      PATCH = 3
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
