require 'spec_helper'

module BackpackTF
  describe 'ItemPrice' do
    describe 'instance of ItemPrice' do
      context "A typical item that does NOT have the quality 'Unusual'" do
        let(:item_price_key) { 'Unique_Tradable_Craftable' }
        let(:item_price_attr) { '{"currency":"metal","value":0.05,"last_update":1336410088,"difference":0}' }
        let (:item_price) { ItemPrice.new(item_price_key, item_price_attr) }

        it 'should respond to these methods' do
          expect(item_price).to respond_to :quality, :tradability, :craftability, :priceindex, :currency, :value, :value_high, :value_raw, :value_high_raw, :last_update, :difference
        end
        it 'should have these values' do
          expect(item_price.quality).to eq :Unique
          expect(item_price.tradability).to eq :Tradable
          expect(item_price.craftability).to eq :Craftable
          expect(item_price.currency).to eq :metal
          expect(item_price.value).to eq 0.05
          expect(item_price.value_high).to be_nil
          expect(item_price.value_raw).to be_nil
          expect(item_price.value_high_raw).to be_nil
          expect(item_price.last_update).to eq 1336410088
          expect(item_price.difference).to eq 0
          expect(item_price.priceindex).to be_nil
        end
      end

      context "An item with the quality 'Unusual'" do
        # the Unusual item being tested is the 'Barnstormer'
        let(:item_price_key) { 'Unusual_Tradable_Craftable' }
        #let(:item_price_attr) {'{"6":{"currency":"keys","value":18,"last_update":1418795322,"difference":280,"value_high":22}}'}
        let(:item_price_attr) {'{"currency":"keys","value":18,"last_update":1418795322,"difference":280,"value_high":22}'}
        let(:item_price) { ItemPrice.new(item_price_key, item_price_attr, 6) }

        it 'should respond to these methods' do
          expect(item_price).to respond_to :quality, :tradability, :craftability, :priceindex, :currency, :value, :value_high, :value_raw, :value_high_raw, :last_update, :difference
        end
        it 'should have these values' do
          expect(item_price.quality).to eq :Unusual
          expect(item_price.tradability).to eq :Tradable
          expect(item_price.craftability).to eq :Craftable
          expect(item_price.currency).to eq :keys
          expect(item_price.value).to eq 18
          expect(item_price.value_high).to eq 22
          expect(item_price.value_raw).to be_nil
          expect(item_price.value_high_raw).to be_nil
          expect(item_price.last_update).to eq 1418795322
          expect(item_price.difference).to eq 280
          expect(item_price.priceindex).to eq 6
        end
      end
    end
  end
end
