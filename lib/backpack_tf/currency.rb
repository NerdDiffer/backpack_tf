require 'backpack_tf/currency/interface'
require 'backpack_tf/currency/response'

module BackpackTF
  # Ruby representations of a JSON response to IGetCurrencies
  class Currency
    include Helpers

    # @return [Fixnum] the quality index of the currency
    attr_reader :quality
    # @return [Fixnum] the internal priceindex of the currency
    attr_reader :priceindex
    # @return [String] the single form of noun that is used in the suffix
    attr_reader :single
    # @return [String] the plural form of noun that is used in the suffix
    attr_reader :plural
    # @return [Fixnum] number of decimal places the price should be rounded to
    attr_reader :round
    # @return [Symbol] currency's craftability (:Craftable or :Non-Craftable)
    attr_reader :craftable
    # @return [Symbol] currency's tradability (:Tradable or :Non-Tradable)
    attr_reader :tradable
    # @return [Fixnum] the definition index of the currency
    attr_reader :defindex
    # @return [Fixnum] Not sure what this attribute means!
    attr_reader :blanket

    # @param name [String] name of currency
    # @param attr [Hash] attributes for Currency object
    # @return [Currency] a new Currency object
    def initialize(name, attr)
      processed_attr = hash_keys_to_sym(attr)

      @name       = name.to_s
      @quality    = processed_attr[:quality]
      @priceindex = processed_attr[:priceindex]
      @single     = processed_attr[:single]
      @plural     = processed_attr[:plural]
      @round      = processed_attr[:round]
      @craftable  = processed_attr[:craftable].to_sym
      @tradable   = processed_attr[:tradable].to_sym
      @defindex   = processed_attr[:defindex]
      @blanket    = processed_attr[:blanket]
    end
  end
end
