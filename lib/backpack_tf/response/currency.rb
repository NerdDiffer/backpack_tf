module BackpackTF
  class Currency
    class Response < BackpackTF::Response
      @response = nil
      @currencies = nil

      def self.currencies
        response if @response.nil?
        @currencies = @response['currencies'].inject({}) do |acc, (name, attr)|
          acc[name] = BackpackTF::Currency.new(name, attr)
          acc
        end
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
