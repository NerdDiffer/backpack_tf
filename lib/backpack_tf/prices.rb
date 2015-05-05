module BackpackTF

  # ruby representations of a JSON response to
  # `IGetPrices`['response']
  class Prices

    include BackpackTF::Response
    include BackpackTF::Finder

    @interface = :IGetPrices

    def self.items
      @@items = @response[:items]
    end

    def initialize
      msg = "This class is meant to receive the JSON response from the #{self.class.interface} interface."
      msg << "It holds a Hash array of prices of items, but not is meant to be instantiated."
      msg << "See the Item class if you are interested in an item."
      msg << "However, information on items should be stored in the @items property of #{self.class}."
      raise RuntimeError, msg
    end

  end

end
