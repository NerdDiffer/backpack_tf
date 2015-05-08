module BackpackTF
  class Response

    ############################
    # CLASS METHODS
    ############################

    def self.interface; @interface; end

    def self.to_sym
      self.name.to_sym
    end

    @responses = {}

    def self.responses key_val = nil
      unless key_val.nil?
        key_val = { key_val => nil } unless key_val.class == Hash
        key = key_val.keys.first
        val = key_val.values.first

        if val.nil?
          @responses[key]
        elsif key == :reset && val == :confirm
          @responses = {}
        else
          @responses[key] = hash_keys_to_sym(val)
        end

      end

      @responses
    end

    # checks the data type of the keys of a Hash object
    # if the key is a String, then changes it to a Symbol
    # otherwise, leaves it as is
    def self.hash_keys_to_sym hash
      hash.each_pair.inject({}) do |new_hash, (key, val)|
        unless key.class == String
          new_hash[key] = val
        else
          new_hash[key.to_sym] = val
        end
        new_hash
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
