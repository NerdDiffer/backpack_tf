module BackpackTF
  # Access all BackpackTF APIs through here
  class Client
    include HTTParty

    # @param key [String] Your backpack.tf API key
    # @return [Client] a new Client object
    def initialize(key)
      @key = check_key(key)
      httparty_settings
    end

    # @param interface [Symbol] API name to fetch, in singular, snake-case.
    #   For example:
    #   `:currencies`, `:market_prices`, `:prices`, `:price_history`,
    #   `:special_items`, `:users`, `:user_listings`
    # @param query_options [Hash] Additional query string key-value pairs
    # @return [Hash] Parsed JSON response from an API, starting from the
    #   'response' key.
    def fetch(interface, query_options = {})
      get_data(interface, query_options)['response']
    end

    private

    def get_data(action, query_options = {})
      handle_timeouts do
        url = build_url_via(action, query_options)
        self.class.get(url)
      end
    end

    # HTTParty raises an errors after time limit defined by ::default_timeout
    # - if it cannot connect to server, then it raises Net::OpenTimeout
    # - if it cannot read response from server, then it raises Net::ReadTimeout
    def handle_timeouts
      yield
    rescue Net::OpenTimeout, Net::ReadTimeout
      {}
    end

    def httparty_settings
      self.class.base_uri('http://backpack.tf/api')
      self.class.default_timeout(5)
      self.class.default_params(key: @key)
    end

    def check_key(key = nil)
      # This should not matter when running tests.
      warn('--- WARNING: your key is nil ---') if key.nil?

      if key.class == String && (key.length != 24 || key[/\H/])
        msg = 'The key should be a hexadecimal number, 24-digits long'
        fail ArgumentError, msg
      else
        key
      end
    end

    def build_url_via(action, query_options = {})
      base_uri = self.class.base_uri
      interface_url_fragment = select_interface_url_fragment(action)
      base_uri + interface_url_fragment + extract_query_string(query_options)
    end

    def extract_query_string(options = {})
      options.each_pair.map do |key, val|
        if val.class == Array
          "#{key}=#{val.join(',')}"
        else
          "#{key}=#{val}"
        end
      end.join('&')
    end

    def select_interface_url_fragment(action)
      case action
      when :currencies
        Currency::Interface.url_name_and_version
      when :market_prices
        MarketPrice::Interface.url_name_and_version
      when :prices
        Price::Interface.url_name_and_version
      when :price_history
        PriceHistory::Interface.url_name_and_version
      when :special_items
        SpecialItem::Interface.url_name_and_version
      when :users
        User::Interface.url_name_and_version
      when :user_listings
        UserListing::Interface.url_name_and_version
      end
    end
  end
end
