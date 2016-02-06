module BackpackTF
  class Currency
    # Process reponses from IGetCurrencies
    class Response < BackpackTF::Response
      @response = nil
      @currencies = nil

      def self.currencies
        hash = @response['currencies'].each_with_object({}) do |(name, attr), h|
          h[name] = BackpackTF::Currency.new(name, attr)
        end
        @currencies = hash
      end

      def self.name
        @name = @response['name']
      end

      def self.url
        @url = @response['url']
      end
    end
  end
end
