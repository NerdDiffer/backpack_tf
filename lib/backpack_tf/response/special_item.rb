module BackpackTF
  class SpecialItem
    # Process reponses from IGetSpecialItems
    class Response < BackpackTF::Response
      @response = nil
      @items = {}

      def self.items
        response if @response.nil?
        @items = @response['items'].each_with_object({}) do |item, hash|
          name = item['name']
          hash[name] = BackpackTF::SpecialItem.new(name, item)
        end
      end
    end
  end
end
