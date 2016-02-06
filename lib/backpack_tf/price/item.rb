module BackpackTF
  module Price
    # This lives inside the `@items` hash of BackpackTF::Price::Response
    class Item
      # @return [String] the name of item
      attr_reader :item_name
      # @return [Fixnum] an index number as per TF2's Item Schema
      attr_reader :defindex
      # @return [Hash<Fixnum, ItemPrice>] a hash object
      attr_reader :prices

      def initialize(item_name, attr)
        # TODO: remove this line if smoke test passes w/o its involvement
        # attr = JSON.parse(attr) unless attr.class == Hash
        @item_name = item_name
        @defindex  = process_defindex(attr['defindex'])
        @prices    = generate_prices_hash(attr)
      end

      private

      def process_defindex(arr)
        return nil if arr.length == 0
        return arr[0] if arr.length == 1
        arr
      end

      def generate_prices_hash(input_hash)
        prices = input_hash['prices']

        prices.each_with_object({}) do |(quality_idx), prices_acc|
          tradables = prices[quality_idx]

          tradables.each_key do |tradability|
            craftables = tradables[tradability]

            craftables.each_key do |craftability|
              price_indices = craftables[craftability]

              price_indices.each_key do |price_idx|
                item_price_data = price_indices[price_idx]
                key_str = keyname(quality_idx, tradability, craftability, price_idx)

                if price_idx == '0'
                  build_item_price(prices_acc, key_str, item_price_data)
                elsif quality_idx == '5'
                  build_unusual_item_price(prices_acc, key_str, item_price_data, price_idx)
                else
                  build_crate_price(prices_acc, key_str, item_price_data, price_idx)
                end
              end
            end
          end
        end
      end

      def quality_index_to_name(index)
        ItemPrice.qualities[index.to_i]
      end

      def keyname(quality_idx, tradability, craftability, price_idx = '0')
        quality = quality_index_to_name(quality_idx)
        key_str = "#{quality}_#{tradability}_#{craftability}"
        key_str << "_##{price_idx}" unless price_idx == '0'
        key_str
      end

      def build_item_price(accumulation, key_str, attr)
        item_price = ItemPrice.new(key_str, attr)
        accumulation[key_str] = item_price
        accumulation
      end

      def build_unusual_item_price(accumulation, key_str, attr, price_idx)
        item_price = ItemPrice.new(key_str, attr, price_idx)
        accumulation[item_price.effect] = item_price
        accumulation
      end

      def build_crate_price(accumulation, key_str, attr, price_idx)
        item_price = ItemPrice.new(key_str, attr, price_idx)
        accumulation[key_str] = item_price
        accumulation
      end
    end
  end
end
