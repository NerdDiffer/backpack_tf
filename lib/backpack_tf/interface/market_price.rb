module BackpackTF
  class MarketPrice
    # Access the IGetMarketPrices interface
    class Interface < BackpackTF::Interface
      @name = :IGetMarketPrices
      @version = 1
    end
  end
end
