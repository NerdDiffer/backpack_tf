module BackpackTF

  class ItemPrice

    attr_reader :quality, :tradability, :craftability, :priceindex,
      :currency, :value, :value_high, :value_raw, :value_high_raw,
      :last_update, :difference

    def initialize
    end

    # mapping official API quality integers to quality names
    # https://wiki.teamfortress.com/wiki/WebAPI/GetSchema#Result_Data
    @@qualities = [
      'Normal',
      'Genuine',
      nil,
      'Vintage',
      nil,
      'Unusual',
      'Unique',
      'Community',
      'Valve',
      'Self-Made',
      nil,
      'Strange',
      nil,
      'Haunted',
      "Collector's"
    ]

    @@tradabilities = [:Tradable, :Untradable]
    @@craftabilities = [:Craftable, :Uncraftable]
    
    # returns JSON data for the item
    # does not return data for items with a special particle effect
    def self.get_item_price quality, item_name
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

  end

end
