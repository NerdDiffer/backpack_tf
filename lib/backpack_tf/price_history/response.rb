module BackpackTF
  class PriceHistory
    # Process reponses from IGetPriceHistory
    class Response < BackpackTF::Response
      @response = nil
      @history = []

      def self.history
        @history = @response['history'].map do |attr|
          BackpackTF::PriceHistory.new(attr)
        end
      end
    end
  end
end
