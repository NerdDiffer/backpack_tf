module BackpackTF
  class User
    # Access the IGetUsers interface
    class Interface < BackpackTF::Interface
      class << self
        attr_reader :steamids
      end

      @name = :IGetUsers
      @version = 3

      def self.defaults(options = {})
        @steamids = options[:steamids] || nil
        super(options)
      end
    end
  end
end
