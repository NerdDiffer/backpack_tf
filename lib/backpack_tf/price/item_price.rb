module BackpackTF
  module Price
    # Price for an individual item.
    #   This lives inside the `@prices` hash of a BackpackTF::Item object.
    class ItemPrice
      KEYNAME_DELIMITER = '_'.freeze

      class << self
        # @return [Array<Symbol>] maps quality integers to quality names
        #   see: https://wiki.teamfortress.com/wiki/WebAPI/GetSchema#Result_Data
        attr_reader :qualities
        # @return [Array<Symbol>] possible values for tradable
        attr_reader :tradabilities
        # @return [Array<Symbol>] possible values for craftable
        attr_reader :craftabilities
      end

      @qualities = [
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
      @tradabilities  = [:Tradable, :'Non-Tradable']
      @craftabilities = [:Craftable, :'Non-Craftable']

      def self.quality_name_to_index(quality)
        qualities.index(quality.to_sym) unless quality.nil?
      end

      # @return [String] item quality
      attr_reader :quality
      # @return [Symbol] either :Tradable or :'Non-Tradable'
      attr_reader :tradability
      # @return [Symbol] either :Craftable or :'Non-Craftable'
      attr_reader :craftability
      # @return [NilClass or Fixnum] May signify crate series or unusual effect
      attr_reader :priceindex
      # @return [Symbol] The currency of the item's price
      attr_reader :currency
      # @return [Float] The value of the item in said currency
      attr_reader :value
      # @return [Float] The item's upper value in said currency.
      #   Only set if the item has a price range
      attr_reader :value_high
      # @return [Float] The item's value in the lowest currency w/o rounding.
      #   If raw is set to 2, this is the lower value if a high value exists.
      #   Otherwise, this is the average between the high and low value.
      #   Requires raw to be enabled.
      attr_reader :value_raw
      # @return [Float] The item's value in the lowest currency w/o rounding.
      #   Requires for 'raw' to be enabled & set to 2.
      attr_reader :value_high_raw
      # @return [Fixnum] A timestamp of when the price was last updated
      attr_reader :last_update
      # @return [Fixnum] A relative difference between the former price & the
      #   current price. If 0, assume new price.
      attr_reader :difference
      # @return [String] Which particle effect, if any
      attr_reader :effect

      # @param key [Array], describes the quality, tradability & craftability
      #   of an item. For example: ['Unique', 'Tradable', 'Craftable']
      #   It is directly related to the path you would take to find
      #   the price from the `@prices` attribute of that item.
      # @param attr [Hash], collection of attributes for the price
      # @param priceindex [nil, Fixnum, Array], not needed unless the item is
      #   Unusual, a Crate, a Strangifier, a Chemistry set or has dual qualities
      def initialize(key, attr, priceindex = nil)
        # TODO: remove this line if smoke test passes w/o its involvement
        # attr = JSON.parse(attr) unless attr.class == Hash
        key = split_key(key)

        @quality        = key[0].to_sym
        @tradability    = key[1].to_sym
        @craftability   = key[2].to_sym
        @currency       = currency_or_nil(attr)
        @value          = attr['value']
        @value_high     = attr['value_high']
        @value_raw      = attr['value_raw']
        @value_high_raw = attr['value_high_raw']
        @last_update    = attr['last_update']
        @difference     = attr['difference']
        @priceindex     = priceindex
        @effect         = pick_particle_effect(priceindex)
      end

      private

      def split_key(key)
        key.split(KEYNAME_DELIMITER)
      end

      def currency_or_nil(attr)
        curr = attr.fetch('currency', nil)
        curr.to_sym unless curr.nil?
      end

      def pick_particle_effect(priceindex)
        ParticleEffect.list[priceindex.to_i]
      end
    end
  end
end
