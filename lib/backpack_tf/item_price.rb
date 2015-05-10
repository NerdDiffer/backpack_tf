module BackpackTF

  class ItemPrice

    KEYNAME_DELIMITER = '_'

    ###########################
    #      Class Methods
    ###########################

    # mapping official API quality integers to quality names
    # https://wiki.teamfortress.com/wiki/WebAPI/GetSchema#Result_Data
    @@qualities = [
      :Normal,
      :Genuine,
      nil,
      :Vintage,
      nil,
      :Unusual,
      :Unique,
      :Community,
      :Valve,
      :"Self-Made",
      nil,
      :Strange,
      nil,
      :Haunted,
      :"Collector's"
    ]

    @@tradabilities = [:Tradable, :'Non-Tradable']
    @@craftabilities = [:Craftable, :'Non-Craftable']
    @@required_keys = ['currency', 'value', 'last_update', 'difference']

    def self.qualities; @@qualities; end
    def self.required_keys; @@required_keys; end

    def self.quality_name_to_index q
      @@qualities.index(q.to_sym) unless q.nil?
    end

    ###########################
    #     Instance Methods
    ###########################

    # @return [String] the quality of the item being priced, converted to String
    attr_reader :quality
    # @return [Symbol] either :Tradable or :'Non-Tradable'
    attr_reader :tradability
    # @return [Symbol] either :Craftable or :'Non-Craftable'
    attr_reader :craftability
    # @return [NilClass or Fixnum] Primarily used to signify crate series or unusual effect. Otherwise, this is 0
    attr_reader :priceindex
    # @return [Symbol] The currency that the item's price is based on
    attr_reader :currency
    # @return [Float] The value of the item in said currency
    attr_reader :value
    # @return [Float] The item's upper value measured in said currency. only set if the item has a price range
    attr_reader :value_high
    # @return [Float] The item's value in the lowest currency without rounding. If raw is set to 2, this is the lower value if a high value exists. Otherwise, this is the average between the high and low value. Requires raw to be enabled. 
    attr_reader :value_raw
    # @return [Float] The item's value in the lowest currency without rounding. Reques raw to be enabled and set to 2
    attr_reader :value_high_raw
    # @return [Fixnum]  A timestamp of when the price was last updated
    attr_reader :last_update
    # @return [Fixnum]  A relative difference between the former price and the current price. If 0, assume new price.
    attr_reader :difference

    def initialize key, attr, priceindex = nil
      attr = JSON.parse(attr) unless attr.class == Hash

      key = key.split(KEYNAME_DELIMITER)
      key = process_key(key)

      validate_attributes(attr)

      @priceindex     = priceindex
      @quality        = key[0]
      @tradability    = key[1]
      @craftability   = key[2]
      @currency       = attr['currency'].to_sym
      @value          = attr['value']
      @value_high     = attr['value_high']
      @value_raw      = attr['value_raw']
      @value_high_raw = attr['value_high_raw']
      @last_update    = attr['last_update']
      @difference     = attr['difference']
    end

    private
    # requires the key to an Array with length of 3 or more
    # converts each element to a Symbol object
    # The 3 bits of info are subject to a NameError if any one of them is invalid
    # @return [Array] an Array of Symbol objects
    # @raises NameError, ArgumentError
    def process_key key

      unless key.length >= 3
        raise ArgumentError, "This key must have a length of 3 or greater"
      end

      key.map! { |bit| bit.to_sym }

      unless @@qualities.include? key[0]
        raise NameError, 'Must include a valid Quality'
      end
      unless @@tradabilities.include? key[1]
        raise NameError, 'Must include a valid Tradability'
      end
      unless @@craftabilities.include? key[2]
        raise NameError, 'Must include a valid Craftability'
      end

      key
    end

    def validate_attributes attributes

      raise TypeError unless attributes.class == Hash

      unless @@required_keys.all? { |k| attributes.keys.member? k }
        msg = "The passed-in hash is required to have at least these 4 keys: "
        msg += "#{self.class.required_keys.join(', ')}"
        raise KeyError, msg
      end

      attributes

    end

  end

end
