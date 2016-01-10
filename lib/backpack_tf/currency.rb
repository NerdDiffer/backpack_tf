# Ruby representations of a JSON response to IGetCurrencies['response']

module BackpackTF
  class Currency < Response
    ###########################
    #     Class Methods
    ###########################

    INTERFACE = :IGetCurrencies
    @interface = INTERFACE
    @response = nil
    @currencies = nil

    def self.response
      @response = superclass.responses[to_sym]
    end

    def self.currencies
      return @response if @response.nil?
      @currencies = response[:currencies]
      hash_keys_to_sym(@currencies)
    end

    ###########################
    #     Instance Methods
    ###########################

    # @return [Fixnum] the quality index of the currency
    attr_reader :quality
    # @return [Fixnum] the internal priceindex of the currency
    attr_reader :priceindex
    # @return [String] the single form of noun that is used in the suffix
    attr_reader :single
    # @return [String] the plural form of noun that is used in the suffix
    attr_reader :plural
    # @return [Fixnum] the number of decimal places the price should be rounded to
    attr_reader :round
    # @return [Symbol] either :Craftable or :Non-Craftable to signify currency's craftability
    attr_reader :craftable
    # @return [Symbol] either :Tradable or :Non-Tradable to signify currency's tradability
    attr_reader :tradable
    # @return [Fixnum] the definition index of the currency
    attr_reader :defindex
    # TODO: what does the :blanket attribute mean?
    # it is set to 0 by default. However, it is set to 1 for :hat.
    # :hat also has an extra property & value :blanket_name => 'Random Craft Hat'
    # @return [Fixnum] 
    attr_reader :blanket

    def initialize name, attr
      attr = check_attr_keys(attr)

      @name       = name.to_s
      @quality    = attr[:quality]
      @priceindex = attr[:priceindex]
      @single     = attr[:single]
      @plural     = attr[:plural]
      @round      = attr[:round]
      @craftable  = attr[:craftable].to_sym
      @tradable   = attr[:tradable].to_sym
      @defindex   = attr[:defindex]
      @blanket    = attr[:blanket]
    end
  end
end
