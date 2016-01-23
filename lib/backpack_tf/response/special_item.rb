module BackpackTF
  class SpecialItem
    class Response < BackpackTF::Response
      @response = nil
      @items = {}

      def self.items
        response if @response.nil?
        @items = @response['items'].each.inject({}) do |hash, item|
          name = item['name']
          hash[name] = BackpackTF::SpecialItem.new(name, item)
          hash
        end
      end
    end
  end
end
