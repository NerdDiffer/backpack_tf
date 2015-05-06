require 'spec_helper'

module BackpackTF
  describe 'Item' do
    let(:expected_keys) do
      ["Strange_Tradable_Craftable", "Collector's_Tradable_Craftable", "Vintage_Tradable_Craftable", "Unique_Tradable_Craftable", "Unique_Tradable_Non-Craftable"]
    end

    xdescribe '::generate_price_keys'  do
      it 'includes these keys' do
        keys = Item.generate_price_keys(stub)
        keys.each{ |key| expect(expected_keys).to include(key) }
      end
      it 'produces all of these keys' do
        keys = Item.generate_price_keys(stub['prices'])
        expect(keys).to match_array expected_keys
      end
    end

    describe 'instance of Item' do
      context 'a typical game item, which does not have any item qualities of Unusual' do
        let(:item_name) { 'Kritzkrieg' }
        let(:stub) do
          JSON.parse '{"defindex":[35],"prices":{"11":{"Tradable":{"Craftable":[{"currency":"keys","value":18,"last_update":1430665867,"difference":-18.495}]}},"14":{"Tradable":{"Craftable":[{"currency":"keys","value":9,"last_update":1416841372,"difference":11.385}]}},"3":{"Tradable":{"Craftable":[{"currency":"metal","value":0.66,"last_update":1426439779,"difference":0.33}]}},"6":{"Tradable":{"Craftable":[{"currency":"metal","value":0.05,"last_update":1336410088,"difference":0}],"Non-Craftable":[{"currency":"metal","value":0.05,"last_update":1362791812,"difference":0.03}]}}}}'
        end
        let(:item) { Item.new(item_name, stub) }
        let(:prices_hash) { item.gen_prices_hash(stub) }

        it 'should respond to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices, :gen_prices_hash
        end

        it 'should have these values' do
          expect(item.item_name).to eq 'Kritzkrieg'
          expect(item.defindex).to eq 35
        end

        describe '#gen_prices_hash' do
          it 'generates a Hash' do
            expect(prices_hash).to be_instance_of Hash
          end
          it 'each key is a String' do
            expect(prices_hash.keys).to all be_a String
          end
          it 'includes these keys' do
            prices_hash.keys.each{ |key| expect(expected_keys).to include(key) }
          end
          it 'value of each key is an ItemPrice object' do
            expect(prices_hash.values).to all be_an ItemPrice
          end
        end

        describe 'the @prices instance variable' do
          it 'is a Hash' do
            expect(item.prices).to be_a Hash
          end
          it 'include these keys' do
            item.prices.keys.each{|key| expect(expected_keys).to include(key)}
          end
          xit 'has all of these keys' do
            expect(item.prices.keys).to eq expected_keys
          end
          it 'each value is an ItemPrice object' do
            expect(item.prices.values).to all be_an ItemPrice
          end
        end
      end

      context 'an item with a quality of Unusual' do
        let(:item_name) { 'Barnstormer' }
        let(:stub) { JSON.parse(file_fixture('item_unusual.json')) }
        let(:item) { Item.new(item_name, stub) }
        let(:prices_hash) { item.gen_prices_hash(stub) }

        it 'should respond to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices, :gen_prices_hash
        end
        it 'should have these values' do
          expect(item.item_name).to eq 'Barnstormer'
          expect(item.defindex).to eq 988
        end

        describe '#gen_prices_hash' do
          it 'generates a Hash' do
            expect(prices_hash).to be_instance_of Hash
          end
          it 'each key is a String' do
            expect(prices_hash.keys).to all be_a String
          end
          it 'value of each key is an ItemPrice object' do
            expect(prices_hash.values).to all be_an ItemPrice
          end
        end
        describe 'the @prices instance variable' do
          it 'is a Hash' do
            expect(item.prices).to be_a Hash
          end
          it 'each value is an ItemPrice object' do
            expect(item.prices.values).to all be_an ItemPrice
          end
        end
      end

      context 'an item with an unconventional structure' do
        let(:item_name) { 'Aqua Summer 2013 Coolor' }
        let(:stub) { JSON.parse(file_fixture('item_with_unconventional_structure.json')) }
        let(:item) { Item.new(item_name, stub) }
        let(:prices_hash) { item.gen_prices_hash(stub) }

        it 'should respond to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices, :gen_prices_hash
        end
        it 'should have these values' do
          expect(item.item_name).to eq 'Aqua Summer 2013 Coolor'
          expect(item.defindex).to eq 5650
        end

        describe '#gen_prices_hash' do
          it 'generates a Hash' do
            expect(prices_hash).to be_instance_of Hash
          end
          it 'each key is a String' do
            expect(prices_hash.keys).to all be_a String
          end
          it 'value of each key is an ItemPrice object' do
            expect(prices_hash.values).to all be_an ItemPrice
          end
        end
        describe 'the @prices instance variable' do
          it 'is a Hash' do
            expect(item.prices).to be_a Hash
          end
          it 'each value is an ItemPrice object' do
            expect(item.prices.values).to all be_an ItemPrice
          end
        end
      end

      context 'an item that has no `defindex` or has a negative `defindex`' do
        let(:item_name) { 'Strange Part: Fires Survived' }
        let(:stub) { JSON.parse(file_fixture('item_without_defindex.json')) }
        let(:item) { Item.new(item_name, stub) }
        let(:prices_hash) { item.gen_prices_hash(stub) }

        it 'should respond to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices, :gen_prices_hash
        end
        it 'should have these values' do
          expect(item.item_name).to eq 'Strange Part: Fires Survived'
          expect(item.defindex).to eq nil
        end

        describe '#gen_prices_hash' do
          it 'generates a Hash' do
            expect(prices_hash).to be_instance_of Hash
          end
          it 'each key is a String' do
            expect(prices_hash.keys).to all be_a String
          end
          it 'value of each key is an ItemPrice object' do
            expect(prices_hash.values).to all be_an ItemPrice
          end
        end
        describe 'the @prices instance variable' do
          it 'is a Hash' do
            expect(item.prices).to be_a Hash
          end
          it 'each value is an ItemPrice object' do
            expect(item.prices.values).to all be_an ItemPrice
          end
        end
      end

    end
  end
end
