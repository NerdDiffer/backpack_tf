module BackpackTF
  class Client
    include HTTParty

    ###########################
    #     Class Methods
    ###########################

    # store your API key as an environment variable
    # `export <env_var>='<your api key>'`
    @env_var = 'BPTF_API_KEY'

    def self.api_key(key = nil)
      key ||= ENV[@env_var]

      # This should not matter when running tests.
      if key.nil?
        msg =  "--- WARNING ---\n"
        msg << "Assign your API key to an environment variable.\n"
        msg << "ex: `export #{@env_var}=value`\n\n"
        warn(msg)
      end

      if key.class == String && (key.length != 24 || !!key[/\H/])
        msg = "The key should be a hexadecimal number, 24-digits long"
        raise ArgumentError, msg
      else
        key
      end
    end

    # HTTParty settings
    base_uri('http://backpack.tf/api')
    default_timeout(5)
    default_params(key: api_key)

    def self.build_url_via(action, query_options = {})
      interface_url = case action
      when :get_prices, :prices, :price
        "/#{Price::Interface.name}/v#{Price::Interface.version}/?"
      when :get_currencies, :currencies, :currency
        "/#{Currency::Interface.name}/v#{Currency::Interface.version}/?"
      when :get_special_items, :special_items, :special_item, :specialitem
        "/#{SpecialItem::Interface.name}/v#{SpecialItem::Interface.version}/?"
      when :get_users, :users, :user
        "/#{User::Interface.name}/v#{User::Interface.version}/?"
      when :get_user_listings, :user_listings, :user_listing, :userlisting
        "/#{UserListing::Interface.name}/v#{UserListing::Interface.version}/?"
      end

      base_uri + interface_url + extract_query_string(query_options)
    end

    def self.extract_query_string(options = {})
      options.each_pair.map do |key, val|
        unless val.class == Array
          "#{key}=#{val}"
        else
          "#{key}=#{val.join(',')}"
        end
      end.join('&')
    end

    ###########################
    #     Instance Methods
    ###########################

    def fetch(interface, query_options = {})
      get_data(interface, query_options)['response']
    end

    private

    def get_data(action, query_options = {})
      handle_timeouts do
        url = self.class.build_url_via(action, query_options)
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
  end
end
