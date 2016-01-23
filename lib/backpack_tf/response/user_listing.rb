module BackpackTF
  class UserListing
    class Response < BackpackTF::Response
      @response = nil
      @listings = []

      def self.listings
        response if @response.nil?
        @listings = response['listings'].inject([]) do |listings, attr|
          listings << BackpackTF::UserListing.new(attr)
          listings
        end
      end
    end
  end
end
