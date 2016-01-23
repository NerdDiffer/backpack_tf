module BackpackTF
  module Helpers
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def response=(new_data)
        self::Response.response = new_data
      end

      def response
        self::Response.response
      end
    end

    private

    def hash_keys_to_sym hash
      hash.each_pair.inject({}) do |new_hash, (key, val)|
        unless key.class == String
          new_hash[key] = val
        else
          new_hash[key.to_sym] = val
        end
        new_hash
      end
    end
  end
end
