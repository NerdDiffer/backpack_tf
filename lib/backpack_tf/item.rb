module BackpackTF

  class Item

    include BackpackTF::Finder

    ###########################
    #     Class Methods
    ###########################

    #def self.generate_price_keys item_hash
    #  raise TypeError unless item_hash.class == Hash
    #  prices = item_hash['prices']

    #  prices.each_pair.inject([]) do |gen_keys, (key, val)|
    #    quality = BackpackTF::ItemPrice.qualities[key.to_i]
    #    new_key = [quality.to_s]

    #    tradability = val.keys.first
    #    new_key << tradability

    #    craftability = prices[key][tradability].keys.first
    #    new_key << craftability

    #    gen_keys << new_key.join('_')
    #  end

    #end

    ###########################
    #     Instance Methods
    ###########################

    # @return [String] the name of item
    attr_reader :item_name
    # @return [Fixnum] the index on which you can link this item to Team Fortress 2's Item Schema
    attr_reader :defindex
    # @return [Hash<Fixnum, ItemPrice>] a hash object
    attr_reader :prices

    def initialize item_name, attr
      @item_name  = item_name

      unless attr.class == Hash
        attr = JSON.parse(attr) 
      end

      @defindex   = attr['defindex'][0]
      @prices     = gen_prices_hash(attr)
    end

    def gen_prices_hash input_hash

      raise TypeError, 'expecting a Hash object' unless input_hash.class == Hash
      unless input_hash.has_key? 'prices'
        msg = "input_hash must be at the one level above the point where 'prices' is a key in the JSON hash"
        raise KeyError, msg
      end

      prices = input_hash['prices']

      prices.inject({}) do |hash, (key, val)|
        quality = BackpackTF::ItemPrice.qualities[key.to_i]
        new_key = [quality.to_s]

        tradability = val.keys.first
        new_key << tradability

        craftability = prices[key][tradability].keys.first
        new_key << craftability

        new_key = new_key.join('_')

        prefix = prices[key][tradability][craftability]

        if prefix.class == Array
          item_prices = prefix.first
          item_price_obj = ItemPrice.new(new_key, item_prices)
          hash[new_key] = item_price_obj
        elsif prefix.class == Hash
          if prefix.keys.length <= 1
            item_prices = prefix.values[0]
            item_price_obj = ItemPrice.new(new_key, item_prices)
            hash[new_key] = item_price_obj
          else
            prefix.keys.each do |prefix_key|
              temp_key = "#{new_key}_Effect ##{prefix_key.to_i}"
              item_prices = prefix[prefix_key]
              item_price_obj = ItemPrice.new(temp_key, item_prices, prefix_key)
              hash[new_key] = item_price_obj
            end
          end
        end

        hash
      end
    end

  end
end
