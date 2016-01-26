module BackpackTF
  class User
    # Process reponses from IGetUsers
    class Response < BackpackTF::Response
      @response = nil
      @players = {}

      def self.players
        response if @response.nil?
        hash = response['players'].each_with_object({}) do |(id, attr), h|
          h[id] = BackpackTF::User.new(attr)
        end
        @players = hash
      end
    end
  end
end
