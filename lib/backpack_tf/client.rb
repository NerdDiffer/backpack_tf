module BackpackTF

  class Client

    include HTTParty
  
    ###########################
    #     Class Methods
    ###########################

    # store your API key as an environment variable
    # `export <env_var>='<your api key>'`
    @@env_var = 'BPTF_API_KEY'
    def self.env_var; @@env_var; end
  
    def self.api_key key = nil
      default = key || ENV[@@env_var]
  
      if default.nil?
        msg = "Assign your API key to an environment variable.\n"
        msg << "ex: `export #{@@env_var}=value`"
        raise KeyError, msg
      elsif default.class == String && (default.length != 24 || !!default[/\H/])
        msg = "The key should be a hexadecimal number, 24-digits long"
        raise ArgumentError, msg
      else
        default
      end
    end
  
    base_uri 'http://backpack.tf/api'
    default_timeout 5
    default_params(:key => api_key)
  
    ###########################
    #     Instance Methods
    ###########################
    attr_reader :db
  
    def initialize
      @db = Redis.new
    end
  
    # same as get_data, but does not use any caching functionality
    def get_data_simpler action
      handle_timeouts do
        url = build_url_via(action)
        self.class.get(url)['response']
      end
    end
  
    def get_data action, query_options = {}
      handle_timeouts do
        handle_caching(action) do
          url = build_url_via(action, query_options)
          self.class.get(url)['response']
        end
      end
    end
  
    private
  
    # checks for existence of a key in Redis database
    # if available, returns the results
    # otherwise, yields to passed-in block & stores result in Redis
    def handle_caching(options)
      cached = @db.get(generate_cache_key(options))
      unless cached.nil?
        JSON[cached]
      else
        yield.tap do |results|
          @db.set(generate_cache_key(options), results.to_json)
        end
      end
    end
  
    # builds a unique key to store cached response.
    #   the key is based on which type of request & for which ID.
    def generate_cache_key(action)
      datestamp = Time.now.strftime("%Y-%m-%d")
      case action
      when :get_prices
        "pricing_data:#{ datestamp }"
      when :get_currencies
        "currency_data:#{ datestamp }"
      end
    end
  
    # HTTParty raises an errors after time limit defined by ::default_timeout
    # * if it cannot connect to server, then it raises Net::OpenTimeout
    # * if it cannot read response from server, then it raises Net::ReadTimeout
    # if one of those happen, then an empty hash is returned
    def handle_timeouts
      begin
        yield
      rescue Net::OpenTimeout, Net::ReadTimeout
        {}
      end
    end
  
    def build_url_via action, query_options = {}
      case action
      when :get_prices
        version = 4
        interface_url = "/IGetPrices/v#{version}/?"
      when :get_currencies
        version = 1
        interface_url = "/IGetCurrencies/v#{version}/?"
      when :get_special_items
        version = 1
        interface_url = "/IGetSpecialItems/v#{version}/?"
      when :get_users
        version = 3
        interface_url = "/IGetUsers/v#{version}/?"
      when :get_user_listings
        version = 1
        interface_url = "/IGetUserListings/v#{version}/?"
      else
        raise ArgumentError, 'pass in valid action as a Symbol object'
      end
  
      self.class.base_uri + interface_url + extract_query_string(query_options)
    end

    def extract_query_string options = {}
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
