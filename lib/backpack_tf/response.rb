module BackpackTF
  module Response

    def self.included(other)
      puts "#{self} included in (#{other})"
      other.extend(ClassMethods)
      super
    end

    module ClassMethods

      @response = nil
      def interface; @interface; end

      def response force_update = false
        # if force is true, set value of @response to results of ::fetch
        # otherwise, use a `nil guard` to return @response
        #   if the value is already set, then it returns value of @response
        #   if the value is not set, then it runs ::fetch
        force_update ?
          @response = fetch :
          @response ||= fetch
      end

      def fetch client_stuff
        @response = hash_keys_to_sym(client_stuff)
      end

      # checks the data type of the keys of a Hash object
      # if the key is a String, then changes it to a Symbol
      # otherwise, leaves it as is
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

    ############################
    # PRIVATE INSTANCE METHODS
    ############################
    private
    def check_attr_keys attr
      raise TypeError, 'pass in a Hash object' unless attr.class == Hash 

      unless attr.keys.all? { |k| k.class == String }
        raise TypeError, 'all keys must be String object'
      end

      self.class.hash_keys_to_sym(attr)
    end

  end
end
