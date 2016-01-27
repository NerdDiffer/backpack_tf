module BackpackTF
  module Price
    # Access the IGetPrices interface
    class Interface < BackpackTF::Interface
      class << self
        attr_reader :raw, :since
      end

      @name = :IGetPrices
      @version = 4

      def self.defaults(options)
        @raw = options[:raw] || nil
        @since = options[:since] || nil
        super(options)
      end
    end
  end
end
