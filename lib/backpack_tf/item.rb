module BackpackTF

  class Item

    include BackpackTF::Finder

    ###########################
    #     Class Methods
    ###########################

    def self.generate_price_keys prices, option = nil
      prices
    end

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
      @item_name = item_name
      @defindex = attr['defindex'][0]
      @prices = attr['prices']
    end

  end
end
