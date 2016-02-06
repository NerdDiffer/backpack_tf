module BackpackTF
  module Price
    # Process reponses from IGetPrices
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
        @items ||= generate_items
      end

      def self.generate_items
        @response['items'].each_with_object({}) do |(name), items|
          defindex = @response['items'][name]['defindex'][0]

          if defindex.nil? || defindex < 0
            # ignore this item
          else
            items[name] = Item.new(name, @response['items'][name])
          end
          items
        end
      end
    end
  end
end
