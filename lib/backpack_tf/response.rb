module BackpackTF
  class Response
    class << self
      attr_accessor :response
    end

    def self.success
      @response['success']
    end

    def self.message
      @response['message']
    end

    def self.current_time
      @response['current_time']
    end
  end
end
