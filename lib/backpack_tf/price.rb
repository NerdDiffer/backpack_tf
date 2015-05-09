module BackpackTF

  # ruby representations of a JSON response to
  # `IGetPrices`['response']
  class Price < Response

    INTERFACE = :IGetPrices
    @interface = INTERFACE
    @response = nil
    @items = nil

    ############################
    # CLASS METHODS
    ############################

    def self.response
      @response = superclass.responses[to_sym]
    end

    def self.items opt = nil
      if @items.nil?
        @items = generate_items
      else
        @items
      end
    end

    def self.generate_items
      @response[:items].inject({}) do |items, (name)|
        defindex = @response[:items][name]['defindex'][0]

        if defindex.nil? || defindex < 0
          items
        else
          items[name] = Item.new(name, @response[:items][name])
          items
        end
      end
    end

    def self.find_item_by_name item_name, opt = nil

      items if @items.nil?

      if @items[item_name].nil?
        raise KeyError, "item with the name #{item_name} was not found"
      else
        if opt.nil?
          @items[item_name]
        elsif @items[item_name].respond_to? opt
          @items[item_name].public_send(opt)
        else
          raise KeyError, "the item, #{item_name} does not have that attribute"
        end
      end
    end

    def self.random_item opt = nil

      items if @items.nil?

      case opt
      when :prices, :price
        @items[@items.keys.sample].prices
      else
        @items.keys.sample
      end
    end

    ############################
    # INSTANCE METHODS
    ############################

    def initialize
      msg = "This class is meant to receive the JSON response from the #{self.class.interface} interface."
      msg << "It holds a Hash array of prices of items, but not is meant to be instantiated."
      msg << "See the Item class if you are interested in an item."
      msg << "However, information on items should be stored in the @items property of #{self.class}."
      raise RuntimeError, msg
    end

  end

end
