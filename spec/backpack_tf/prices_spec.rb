require 'spec_helper'

module BackpackTF
  describe 'Prices' do
    describe 'Prices class' do

      it 'has these default attributes' do
        expect(Prices.interface).to eq :IGetPrices
      end

      describe 'accessing the IGetPrices interface' do
        context 'a successful response' do
          it 'returns the fixture and sets to @@items variable' do
            stub_http_response_with('prices.json')
            opts = { :app_id => 440, :compress => 1 }
            Prices.fetch(Client.new.get_data(:get_prices, opts)['response'])
            expect(Prices.items).not_to be_nil
          end

          it 'the response attribute should have these keys' do
            expect(Prices.response.keys).to match_array [:success, :current_time, :raw_usd_value, :usd_currency, :usd_currency_index, :items]
          end

          it 'the keys of the response attribute should have these values' do
            expect(Prices.response[:success]).to eq 1
            expect(Prices.response[:message]).to eq nil
            expect(Prices.response[:current_time]).to eq 1430785805
            expect(Prices.response[:raw_usd_value]).to eq 0.115
            expect(Prices.response[:usd_currency]).to eq 'metal'
            expect(Prices.response[:usd_currency_index]).to eq 5002
          end
        end
      end

      describe '::items' do
        context 'describing the @@items attribute' do
          it 'should be a Hash object' do
            expect(Prices.items).to be_instance_of Hash
          end
          xit 'should have this many keys' do
            expect(Prices.items.keys.length).to be 1661
          end
          it 'each key should be a String' do
            expect(Prices.items.keys).to all be_a String
          end
          it 'each value should be an Item' do
            expect(Prices.items.values).to all be_an Item
          end
        end

        context 'using keys to generate Item objects' do
          let(:random_key) { Prices.items.keys.sample }
          let(:item) { Prices.items[random_key] }

          it 'generates an Item object' do
            expect(item).to be_instance_of Item
          end
          it 'the Item object responds to these methods' do
            expect(item).to respond_to :item_name, :defindex, :prices
          end
          it 'uses the key to assign a value to the @item_name property of the Item' do
            expect(random_key).to eq item.item_name
          end
          it 'passes itself to be stored in the @prices attribute of the Item object' do
            expect(Prices.items[random_key].prices).to eq item.prices
          end
        end
      end
    end

    describe 'instances of Prices' do
      it 'raises an error when trying to instantiate this class' do
        expect{Prices.new}.to raise_error RuntimeError
      end
    end

  end
end
