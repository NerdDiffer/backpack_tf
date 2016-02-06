require 'backpack_tf/special_item/interface'
require 'backpack_tf/special_item/response'

module BackpackTF
  # Ruby representations of a JSON response to IGetSpecialItems
  class SpecialItem
    include Helpers

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

    # @param name [String] Name of the SpecialItem.
    # @param attr [Hash] Attributes.
    # @return [SpecialItem] A new SpecialItem object.
    def initialize(name, attr)
      attr = hash_keys_to_sym(attr)

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
