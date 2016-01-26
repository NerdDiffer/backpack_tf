module BackpackTF
  class UserListing
    # Access the IGetUserListings interface
    class Interface < BackpackTF::Interface
      class << self
        attr_reader :steamid
      end

      @name = :IGetUserListings
      @version = 2

      def self.defaults(options)
        @steamid = options[:steamid] || nil
        super(options)
      end
    end
  end
end
