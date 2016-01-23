require 'backpack_tf/response/user_listing'
require 'backpack_tf/interface/user_listing'

module BackpackTF
  # Ruby representations of a JSON response to IGetUserListings
  class UserListing
    include Helpers

    attr_reader :id
    attr_reader :bump
    attr_reader :created
    attr_reader :currencies
    attr_reader :item
    attr_reader :details
    attr_reader :meta
    attr_reader :buyout

    def initialize attr
      attr = hash_keys_to_sym(attr)

      @id = attr[:id].to_sym
      @bump = attr[:bump]
      @created = attr[:created]
      @currencies = attr[:currencies]
      @item = set_keys_of_key_to_symbols(attr[:item], 'attributes')
      @details = attr[:details]
      @meta = hash_keys_to_sym(attr[:meta])
      @buyout = attr[:buyout]
    end

    private

    def set_keys_of_key_to_symbols attr, key
      return nil unless attr.has_key? key

      item_attributes = attr[key].map do |set_of_attr|
        hash_keys_to_sym(set_of_attr)
      end
      attr[key] = item_attributes

      hash_keys_to_sym(attr)
    end
  end
end
