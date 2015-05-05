module BackpackTF

  # ruby representations of a JSON response to
  # `IGetPrices`['response']
  class Prices

    include BackpackTF::Response

    @interface = :IGetPrices

    def self.items
      @@items = @response[:items]
    end

    def self.defindex_to_item_name defindex
      items = get_items_hash
      keys = items.keys#.shuffle

      i = 0
      while i < keys.length
        current_defindex = items[keys[i]]['defindex']
        if(current_defindex[0] == defindex)
          return keys[i]
        end
        i += 1
      end
      raise KeyError, "item with a defindex of #{defindex} was not found"
    end

    def self.get_name_of_random_item
      items = get_items_hash
      items.keys.sample
    end

    # returns JSON representation of pricing for the item
    def self.find_item_by_name item_name
      items = get_items_hash
      if items[item_name].nil?
        raise KeyError, "item with the name #{item_name} was not found"
      else
        items[item_name]
      end
    end

    # @param [String] item_name, the item name (according to item_name of item's schema)
    # @param [Symbol] type, checking to see if item is of this type
    # @return [Boolean] `true` if the item is the type
    def self.is_item_of_type? item_name, type = :weapon
      item = find_item_by_name(item_name)
      defindex = item['defindex'][0]
      tf2_item = Trade.tf2_item_schema.items[defindex]

      case type
      when :cosmetic
        tf2_item[:item_class] == 'tf_wearable'
      else
        tf2_item[:item_slot] == 'primary' ||
          tf2_item[:item_slot] == 'secondary' ||
          tf2_item[:item_slot] == 'melee'
      end
    end

    def initialize
      msg = "This class is meant to receive the JSON response from the #{self.class.interface} interface. It holds a Hash array of prices of items, but not is meant to be instantiated. See the Item class if you are interested in an item. However, information on items should be stored in the @items property of #{self.class}"
      raise RuntimeError, msg
    end

  end

end
