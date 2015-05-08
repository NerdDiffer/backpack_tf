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
  
    def self.build_url_via action, query_options = {}
      case action
      when :get_prices, :prices
        version = 4
        interface_url = "/#{Prices.interface}/v#{version}/?"
      when :get_currencies, :currencies
        version = 1
        interface_url = "/#{Currencies.interface}/v#{version}/?"
      when :get_special_items, :special_items
        version = 1
        interface_url = "/#{SpecialItems.interface}/v#{version}/?"
      when :get_users, :users
        version = 3
        interface_url = "/#{Users.interface}/v#{version}/?"
      when :get_user_listings, :user_listings
        raise RuntimeError, "Unfortunately, this interface is not yet supported."
        #version = 1
        #interface_url = "/IGetUserListings/v#{version}/?"
      else
        raise ArgumentError, 'pass in valid action as a Symbol object'
      end
  
      base_uri + interface_url + extract_query_string(query_options)
    end

    def self.extract_query_string options = {}
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
    attr_reader :db
  
    def initialize
      @db = nil 
    end
  
    def fetch interface, query_options = {}
      get_data(interface, query_options)['response']
    end

    def update class_to_update, data_to_update
      send_update_to_master_hash(class_to_update, data_to_update)
      refresh_class_hash(class_to_update)
    end
  
    private
  
    def send_update_to_master_hash class_to_update, data_to_update
      Response.responses( { class_to_update.to_sym => data_to_update } )
    end

    def refresh_class_hash class_to_update
      class_to_update.response
    end

    def get_data action, query_options = {}
      handle_timeouts do
        url = self.class.build_url_via(action, query_options)
        self.class.get(url)
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

  end

end
