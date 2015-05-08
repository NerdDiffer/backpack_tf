module BackpackTF

  # ruby representations of a JSON response to
  # `IGetPrices`['response']
  class Prices < Response

    include BackpackTF::Finder

    INTERFACE = :IGetPrices
    @interface = INTERFACE
    @response = nil
    @@items = nil

    def self.response
      @response = superclass.responses[to_sym]
    end

    def self.items
      if @@items.nil?
        gen_items
      else
        @@items
      end
    end

    def self.gen_items
      @@items = @response[:items].inject({}) do |items, (name)|
        defindex = @response[:items][name]['defindex'][0]

        if defindex.nil? || defindex < 0
          items
        else
          items[name] = Item.new(name, @response[:items][name])
          items
        end
      end
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
