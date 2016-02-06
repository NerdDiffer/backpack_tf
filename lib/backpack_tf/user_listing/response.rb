module BackpackTF
  class UserListing
    # Process reponses from IGetUserListings
    class Response < BackpackTF::Response
      @response = nil
      @listings = []

      def self.listings
        @listings = response['listings'].map do |attr|
          BackpackTF::UserListing.new(attr)
        end
      end
    end
  end
end
