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
      @response ||= superclass.responses[to_sym]
    end

    def self.currencies
      response if @response.nil?
      @currencies = response['currencies']
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
    # What does the :blanket attribute mean?
    # it is set to 0 by default. However, it is set to 1 for :hat.
    # :hat also has an extra property & value :blanket_name => 'Random Craft Hat'
    # @return [Fixnum]
    attr_reader :blanket

    def initialize name, attr
      processed_attr = check_attr_keys(attr)

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
