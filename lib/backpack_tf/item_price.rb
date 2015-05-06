module BackpackTF

  class ItemPrice

    include BackpackTF::Finder

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
      unless self.class.required_keys.all? {|k| attr.keys.member? k }
        raise KeyError, "The passed-in hash is required to have at least these 4 keys: #{self.class.required_keys.join(', ')}"
      end

      key_split = key.split('_')

      @priceindex     = priceindex

      @quality        = key_split[0].to_sym
      @tradability    = key_split[1].to_sym
      @craftability   = key_split[2].to_sym
      @currency       = attr['currency'].to_sym
      @value          = attr['value']
      @value_high     = attr['value_high']
      @value_raw      = attr['value_raw']
      @value_high_raw = attr['value_high_raw']
      @last_update    = attr['last_update']
      @difference     = attr['difference']
    end

    @@required_keys = %w(currency value last_update difference)
    def self.required_keys; @@required_keys; end

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

    def self.qualities; @@qualities; end

    @@tradabilities = [:Tradable, :'Non-Tradable']
    @@craftabilities = [:Craftable, :'Non-Craftable']
    
  end

end
