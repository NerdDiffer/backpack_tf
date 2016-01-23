module BackpackTF
  module Price
    class Response < BackpackTF::Response
      @response = nil
      @items = nil

      def self.raw_usd_value
        @response['raw_usd_value']
      end

      def self.usd_currency
        @response['usd_currency']
      end

      def self.usd_currency_index
        @response['usd_currency_index']
      end

      def self.items
        response if @response.nil?
        @items ||= generate_items
      end

      def self.generate_items
        response if @response.nil?

        @response['items'].inject({}) do |items, (name)|
          defindex = @response['items'][name]['defindex'][0]

          if defindex.nil? || defindex < 0
            items
          else
            items[name] = BackpackTF::Item.new(name, @response['items'][name])
            items
          end
        end
      end
    end
  end
end
