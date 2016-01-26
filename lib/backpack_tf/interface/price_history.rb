module BackpackTF
  class PriceHistory
    # Access the IGetPriceHistory interface
    class Interface < BackpackTF::Interface
      class << self
        attr_reader :item, :quality, :tradable, :craftable, :priceindex
      end

      @name = :IGetPriceHistory
      @version = 1

      def self.defaults(options)
        @item = options[:item] || nil
        @quality = options[:quality] || nil
        @tradable = options[:tradable] || nil
        @craftable = options[:craftable] || nil
        @priceindex = options[:priceindex] || nil
        super(options)
      end
    end
  end
end
