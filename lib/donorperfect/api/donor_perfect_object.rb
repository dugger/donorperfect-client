module Donorperfect
  class DonorPerfectObject
    attr_accessor :client

    def initialize(options)
      @client ||= options.delete(:client)

      options.fetch(:values).each do |k, v|
        send(:"#{k}=", v) if respond_to?(:"#{k}=")
      end
    rescue NoMethodError
      puts "NoMethodError: There is no method for one of the keys in your options: #{options}"
    end

    def format_date(d)
      DateTime.parse(d)
    end

    def to_hash(keys = nil)
      ivs = (keys ? (instance_variables & keys) : instance_variables)
      ivs -= [:@client]
      Hash[*
        ivs.map do |v|
          [v.to_s[1..-1].to_sym, instance_variable_get(v)]
        end.flatten]
    end

    alias to_h to_hash
  end
end
