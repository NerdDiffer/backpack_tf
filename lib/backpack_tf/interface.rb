module BackpackTF
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
  end
end
