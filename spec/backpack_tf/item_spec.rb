require 'spec_helper'

module BackpackTF
  describe 'Item' do
    it 'The Prices class returns the fixture and sets to its @@items variable' do
      stub_http_response_with('prices.json')
      opts = { :app_id => 440, :compress => 1 }
      Prices.fetch(Client.new.get_data(:get_prices, opts)['response'])
      expect(Prices.items).not_to be_nil
    end

    describe 'instance of Item' do

      let (:item) { Item.new('Kritzkrieg', Prices.items['Kritzkrieg']) }

      it 'should respond to these methods' do
        expect(item).to respond_to :item_name, :defindex, :prices
      end

      it 'should have these values' do
        expect(item.item_name).to eq 'Kritzkrieg'
        expect(item.defindex).to eq 35
      end

    end
  end
end
