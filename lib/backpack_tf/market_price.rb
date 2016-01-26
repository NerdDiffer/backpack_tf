require 'backpack_tf/response/market_price'
require 'backpack_tf/interface/market_price'

module BackpackTF
  # Ruby representations of a JSON response to IGetMarketPrices
  class MarketPrice
    include Helpers

    attr_reader :last_updated
    attr_reader :quantity
    attr_reader :value

    def initialize(name, attr)
      attr = hash_keys_to_sym(attr)

      @name         = name.to_s
      @last_updated = attr[:last_updated]
      @quantity     = attr[:quantity]
      @value        = attr[:value]
    end
  end
end
