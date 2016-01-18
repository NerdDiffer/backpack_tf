module BackpackTF
  class Client
    include HTTParty

    def initialize(key)
      @key = check_key(key)
      httparty_settings
    end

    def fetch(interface, query_options = {})
      get_data(interface, query_options)['response']
    end

    private

    def get_data(action, query_options = {})
      handle_timeouts do
        url = build_url_via(action, query_options)
        HTTParty.get(url)
      end
    end

    # HTTParty raises an errors after time limit defined by ::default_timeout
    # - if it cannot connect to server, then it raises Net::OpenTimeout
    # - if it cannot read response from server, then it raises Net::ReadTimeout
    def handle_timeouts
      begin
        yield
      rescue Net::OpenTimeout, Net::ReadTimeout
        {}
      end
    end

    def httparty_settings
      self.class.base_uri('http://backpack.tf/api')
      self.class.default_timeout(5)
      self.class.default_params(key: @key)
    end

    def check_key(key = nil)
      # This should not matter when running tests.
      warn('--- WARNING: your key is nil ---') if key.nil?

      if key.class == String && (key.length != 24 || !!key[/\H/])
        msg = 'The key should be a hexadecimal number, 24-digits long'
        raise ArgumentError, msg
      else
        key
      end
    end

    def build_url_via(action, query_options = {})
      interface_url = case action
      when :get_prices, :prices, :price
        version = 4
        interface_url = "/#{Price::INTERFACE}/v#{version}/?"
      when :get_currencies, :currencies, :currency
        version = 1
        interface_url = "/#{Currency::INTERFACE}/v#{version}/?"
      when :get_special_items, :special_items, :special_item, :specialitem
        version = 1
        interface_url = "/#{SpecialItem::INTERFACE}/v#{version}/?"
      when :get_users, :users, :user
        version = 3
        interface_url = "/#{User::INTERFACE}/v#{version}/?"
      when :get_user_listings, :user_listings, :user_listing, :userlisting
        version = 1
        interface_url = "/#{UserListing::INTERFACE}/v#{version}/?"
      else
        raise ArgumentError, 'pass in valid action as a Symbol object'
      end

      self.class.base_uri + interface_url + extract_query_string(query_options)
    end

    def extract_query_string(options = {})
      options.each_pair.map do |key, val|
        unless val.class == Array
          "#{key}=#{val}"
        else
          "#{key}=#{val.join(',')}"
        end
      end.join('&')
    end
  end
end
