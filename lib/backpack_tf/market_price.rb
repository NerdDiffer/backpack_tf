require 'backpack_tf/market_price/interface'
require 'backpack_tf/market_price/response'

module BackpackTF
  # Ruby representations of a JSON response to IGetMarketPrices
  class MarketPrice
    include Helpers

    attr_reader :last_updated
    attr_reader :quantity
    attr_reader :value

    # @param name [String] The name of the item.
    # @param attr [Hash] Attributes for the item.
    # @return [MarketPrice] A new MarketPrice object.
    def initialize(name, attr)
      attr = hash_keys_to_sym(attr)

      @name         = name.to_s
      @last_updated = attr[:last_updated]
      @quantity     = attr[:quantity]
      @value        = attr[:value]
    end
  end
end
