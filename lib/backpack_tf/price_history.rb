require 'backpack_tf/response/price_history'
require 'backpack_tf/interface/price_history'

module BackpackTF
  class PriceHistory
    include Helpers

    attr_reader :value
    attr_reader :value_high
    attr_reader :currency
    attr_reader :timestamp

    def initialize attr
      attr = hash_keys_to_sym(attr)

      @value      = attr[:value]
      @value_high = attr[:value_high]
      @currency   = attr[:currency]
      @timestamp  = attr[:timestamp]
    end
  end
end
