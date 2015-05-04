require 'spec_helper'

module BackpackTF
  describe 'Item' do
    describe 'instance of Item' do

      let (:item) { Item.new('Kritzkrieg', Price.items['Kritzkrieg']) }

      before :all do
        opts = { :app_id => 440, :compress => 1 }
        Prices.fetch( Client.new.get_data(:get_prices, opts) )
      end

      before do
        VCR.insert_cassette 'pricing_data', :record => :new_episodes
      end

      after do
        VCR.eject_cassette
      end

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
