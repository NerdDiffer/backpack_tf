module BackpackTF
  module Finder

    def self.included(other)
      #puts "#{self} included in (#{other})"
      other.extend(ClassMethods)
      super
    end

    module ClassMethods
      # returns JSON data for the item
      # does not return data for items with a special particle effect
      def get_item_price quality, item_name
        item = find_item_by_name(item_name)
        ind = @@qualities.find_index(quality)

        prefix = item['prices'][ind.to_s]['Tradable']
        if prefix.nil?
          raise(ArgumentError, "The item, #{quality} #{item_name}, is not Tradable")
        end
        prefix = prefix['Craftable']
        if prefix.nil?
          raise(ArgumentError, "The item, #{quality} #{item_name}, is not Craftable")
        end

        # oddly, there are cases (such as the "Lugermorph"), where the 
        # type of the object at this point in the JSON data (saved to the `prefix` variable) 
        # is a Hash object rather than an Array object.
        # That makes the PriceIndex key a String, "0", rather than a Fixnum, 0.
        if prefix[0].nil?
          prefix[0.to_s] 
        else
          prefix[0]
        end
      end

      def defindex_to_item_name defindex
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

      def get_name_of_random_item
        items = get_items_hash
        items.keys.sample
      end

      # returns JSON representation of pricing for the item
      def find_item_by_name item_name
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
      def is_item_of_type? item_name, type = :weapon
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

    end

  end
end
