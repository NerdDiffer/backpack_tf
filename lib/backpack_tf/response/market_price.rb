module BackpackTF
  class MarketPrice
    class Response < BackpackTF::Response
      @response = nil
      @items = {}

      def self.items
        response if @response.nil?
        @items = @response['items'].inject({}) do |acc, (name, attr)|
          acc[name] = BackpackTF::MarketPrice.new(name, attr)
          acc
        end
      end
    end
  end
end
