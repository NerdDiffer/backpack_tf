module BackpackTF
  # Base class for accessing a BackpackTF API
  class Interface
    class << self
      attr_reader :format, :callback, :appid, :name, :version
    end

    @format   = 'json'
    @callback = nil
    @appid    = '440'

    def self.defaults(options = {})
      @format   = options[:format]   || 'json'
      @callback = options[:callback] || nil
      @appid    = options[:appid]    || '440'
    end

    def self.url_name_and_version
      "/#{name}/v#{version}/?"
    end
  end
end
