module BackpackTF
  class UserListing < Response
    INTERFACE = :IGetUserListings

    @interface = INTERFACE
    @response = nil
    @listings = []

    def self.interface; @interface; end

    def self.response
      @response = superclass.responses[to_sym]
    end

    def self.listings
      return @response if response.nil?
      @listings = response[:listings].inject([]) do |listings, attr|
        listings << new(attr)
        listings
      end
    end

    attr_reader :id
    attr_reader :bump
    attr_reader :created
    attr_reader :currencies
    attr_reader :item
    attr_reader :details
    attr_reader :meta
    attr_reader :buyout

    def initialize attr
      attr = check_attr_keys(attr)

      @id = attr[:id].to_sym
      @bump = attr[:bump]
      @created = attr[:created]
      @currencies = attr[:currencies]
      @item = set_keys_of_key_to_symbols(attr[:item], 'attributes')
      @details = attr[:details]
      @meta = self.class.hash_keys_to_sym(attr[:meta])
      @buyout = attr[:buyout]
    end

    private
    # Similar to Response.hash_key_to_sym, except you are returning
    # an Array of Hash objects instead of a Hash.
    def set_keys_of_key_to_symbols attr, key
      return nil unless attr.has_key? key

      item_attributes = attr[key].map do |set_of_attr|
        self.class.hash_keys_to_sym(set_of_attr)
      end
      attr[key] = item_attributes

      self.class.hash_keys_to_sym(attr)
    end
  end
end
