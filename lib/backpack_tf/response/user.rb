module BackpackTF
  class User
    class Response < BackpackTF::Response
      @response = nil
      @players = {}

      def self.players
        response if @response.nil?
        @players = response['players'].inject({}) do |players, (steamid, attr)|
          players[steamid] = BackpackTF::User.new(attr)
          players
        end
      end
    end
  end
end
