module BackpackTF
  # Common methods for objects & response-based classes
  module Helpers
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Accessors/shortcuts for reaching the associated Response class from
    # within a base namespace class.
    module ClassMethods
      def response=(new_data)
        self::Response.response = new_data
      end

      def response
        self::Response.response
      end
    end

    private

    def hash_keys_to_sym(hash)
      hash.each_with_object({}) do |(key, val), new_hash|
        key = key.to_sym if key.class == String
        new_hash[key] = val
      end
    end
  end
end
