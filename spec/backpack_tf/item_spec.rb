require 'spec_helper'

module BackpackTF
  describe 'Item' do
    let (:item) { Item.new('Kritzkrieg', Prices.items['Kritzkrieg']) }
    let(:expected_keys) {["Strange_Tradable_Craftable", "Collector's_Tradable_Craftable", "Vintage_Tradable_Craftable", "Unique_Tradable_Craftable", "Unique_Tradable_Non-Craftable"] }

    it 'The Prices class returns the fixture and sets to its @@items variable' do
      stub_http_response_with('prices.json')
      opts = { :app_id => 440, :compress => 1 }
      Prices.fetch(Client.new.get_data(:get_prices, opts)['response'])
      expect(Prices.items).not_to be_nil
    end

    xit 'looks like this' do
      puts JSON.pretty_generate(item.prices)
    end

    describe '::generate_price_keys'  do
      let(:price_stub) { item.prices }

      it 'produces correct keys' do
        expect(Item.generate_price_keys(price_stub)).to eq expected_keys
      end
    end

    describe 'instance of Item' do
      it 'should respond to these methods' do
        expect(item).to respond_to :item_name, :defindex, :prices
      end

      it 'should have these values' do
        expect(item.item_name).to eq 'Kritzkrieg'
        expect(item.defindex).to eq 35
      end

      describe 'the @prices instance variable' do
        it 'is a Hash' do
          expect(item.prices).to be_a Hash
        end
        it 'has these keys' do
          expect(item.prices.keys).to eq expected_keys
        end
      end

    end
  end
end
