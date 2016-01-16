module BackpackTF
  class SpecialItem < Response
    INTERFACE = :IGetSpecialItems
    @interface = INTERFACE
    @response = nil
    @items = {}

    def self.response
      @response = superclass.responses[to_sym]
    end

    def self.items
      response if @response.nil?
      @items = @response['items'].inject({}) do |hash, item|
        #item = hash_keys_to_sym(item)
        name = item['name']
        hash[name] = new(name, item)
        hash
      end
    end

    attr_reader :name
    attr_reader :item_name
    attr_reader :defindex
    attr_reader :item_class
    attr_reader :item_type_name
    attr_reader :item_description
    attr_reader :proper_name
    attr_reader :item_quality
    attr_reader :min_ilevel
    attr_reader :max_ilevel
    attr_reader :image_url
    attr_reader :image_url_large
    attr_reader :image_url_orig
    attr_reader :image_url_large_orig
    attr_reader :appid

    def initialize name, attr
      attr = check_attr_keys(attr)

      @name                 = name
      @item_name            = attr[:item_name]
      @defindex             = attr[:defindex]
      @item_class           = attr[:item_class]
      @item_type_name       = attr[:item_type_name]
      @item_description     = attr[:item_description]
      @proper_name          = attr[:proper_name]
      @item_quality         = attr[:item_quality]
      @min_ilevel           = attr[:min_ilevel]
      @max_ilevel           = attr[:max_ilevel]
      @image_url            = attr[:image_url]
      @image_url_large      = attr[:image_url_large]
      @image_url_orig       = attr[:image_url_orig]
      @image_url_large_orig = attr[:image_url_large_orig]
      @appid                = attr[:appid]
    end
  end
end
