require 'backpack_tf/user_listing/interface'
require 'backpack_tf/user_listing/response'

module BackpackTF
  # Ruby representations of a JSON response to IGetUserListings
  class UserListing
    include Helpers

    attr_reader :bump
    attr_reader :intent
    attr_reader :currencies
    attr_reader :buyout
    attr_reader :details
    attr_reader :item
    attr_reader :flags
    attr_reader :created
    attr_reader :id

    # @param attr [Hash] Attributes.
    # @return [UserListing] A new UserListing object.
    def initialize(attr)
      attr = hash_keys_to_sym(attr)

      @bump       = attr[:bump]
      @intent     = attr[:intent]
      @currencies = hash_keys_to_sym(attr[:currencies])
      @buyout     = attr[:buyout]
      @details    = attr[:details]
      @item       = set_keys_of_key_to_symbols(attr[:item], 'attributes')
      @flags      = hash_keys_to_sym(attr[:flags])
      @created    = attr[:created]
      @id         = attr[:id]
    end

    private

    def set_keys_of_key_to_symbols(attr, key)
      return nil unless attr.key?(key)

      item_attributes = attr[key].map do |set_of_attr|
        hash_keys_to_sym(set_of_attr)
      end
      attr[key] = item_attributes

      hash_keys_to_sym(attr)
    end
  end
end
