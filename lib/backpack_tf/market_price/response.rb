module BackpackTF
  class MarketPrice
    # Process reponses from IGetMarketPrices
    class Response < BackpackTF::Response
      @response = nil
      @items = {}

      def self.items
        @items = @response['items'].each_with_object({}) do |(name, attr), acc|
          acc[name] = BackpackTF::MarketPrice.new(name, attr)
        end
      end
    end
  end
end
