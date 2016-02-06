module BackpackTF
  # Base class for accessing a BackpackTF API
  class Interface
    class << self
      attr_reader :format, :callback, :appid, :name, :version
    end

    @format   = 'json'
    @callback = nil
    @appid    = '440'

    # @param options [Hash]
    # @option options [String] :format The format desired. Defaults to 'json'.
    # @option options [String] :callback JSONP format only, used for function
    #   call. Defaults to `nil`.
    # @option options [String] :appid The ID of the game. Defaults to '440'.
    # @return [Hash] default options
    def self.defaults(options = {})
      @format   = options[:format]   || 'json'
      @callback = options[:callback] || nil
      @appid    = options[:appid]    || '440'
    end

    # @return [String] URL fragment, ie: `/IGetPrices/v4/?`
    def self.url_name_and_version
      "/#{name}/v#{version}/?"
    end
  end
end
