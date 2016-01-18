require 'spec_helper'

describe 'IGetPrices' do
  describe BackpackTF::Price::Interface do
    it 'has these default attributes' do
      expect(described_class.name).to eq :IGetPrices
      expect(described_class.version).to eq 4
      expect(described_class.raw).to eq nil
      expect(described_class.since).to eq nil
    end
    describe '::defaults' do
      after(:each) do
        described_class.class_eval do
          @raw = nil
          @since = nil
        end
      end
      it 'can modify its values' do
        options = {
          raw: 2,
          since: '1451606400'
        }
        described_class.defaults(options)
        expect(described_class.raw).to eq 2
        expect(described_class.since).to eq '1451606400'
      end
    end
  end

  describe BackpackTF::Price do
    let(:json_response) {
      fixture = file_fixture('prices.json')
      JSON.parse(fixture)['response']
    }
    let(:item) do
      fixture = file_fixture('item_typical.json')
      item_json = JSON.parse(fixture)['Kritzkrieg']
      BackpackTF::Item.new('Kritzkrieg', item_json)
    end
    let(:items) { { 'Kritzkrieg' => item } }

    describe '::response' do
      before :each do
        described_class.class_eval { @response = nil }
        allow(described_class).
          to receive(:to_sym).
          and_return(:'BackpackTF::Price')
        expect(described_class).
          to receive(:to_sym)
        allow(BackpackTF::Response).
          to receive(:responses).
          and_return({ :'BackpackTF::Price' => json_response })
        expect(BackpackTF::Response).
          to receive(:responses)
      end
      after :each do
        described_class.class_eval { @response = nil }
      end

      it 'the keys of the response attribute should have these values' do
        response = described_class.response
        expect(response['success']).to eq 1
        expect(response['message']).to eq nil
        expect(response['current_time']).to eq 1430785805
        expect(response['raw_usd_value']).to eq 0.115
        expect(response['usd_currency']).to eq 'metal'
        expect(response['usd_currency_index']).to eq 5002
      end
    end

    describe '::items' do
      context 'when @items is not nil' do
        before :each do
          described_class.class_eval { @items = { foo: 'bar' } }
        end
        after :each do
          described_class.class_eval { @items = nil }
        end
        it 'returns @items' do
          expected = described_class.class_eval { @items }
          expect(described_class.items).to eq expected
        end
      end

      context 'when @items is nil' do
        before :each do
          described_class.class_eval { @items = nil }
        end
        it 'calls .generate_items' do
          expect(described_class).to receive(:generate_items)
          described_class.items
        end
      end
    end

    describe '::generate_items' do
      context 'using keys to generate BackpackTF::Item objects' do
        before(:context) do
          described_class.class_eval { @response = nil }
        end
        before(:each) do
          allow(described_class).
            to receive(:response).
            and_return(json_response)
          described_class.class_eval { @response = response }
        end
        after(:each) do
          described_class.class_eval { @response = nil }
        end
        it 'each value of hash is a BackpackTF::Item object' do
          actual = described_class.generate_items.values
          expect(actual).to all be_a BackpackTF::Item
        end
        it 'if an item does not have a valid `defindex`, then it is ignored' do
          generated_items = described_class.generate_items
          expect(generated_items['Random Craft Hat']).to be_nil
          expect(generated_items[':weed:']).to be_nil
        end
      end
    end

    describe '::find_item_by_name' do
      context 'when @items is nil' do
        # TODO: write a spec to check that @items gets set when it starts as nil
      end

      context 'when @items is not nil' do
        before(:context) do
          described_class.class_eval { @response = nil }
          described_class.class_eval { @items = nil }
        end
        before(:each) do
          allow(described_class).
            to receive(:items).
            and_return(items)
          described_class.class_eval { @items = items }
        end
        after(:each) do
          described_class.class_eval { @items = nil }
        end

        it 'returns nil when asking for a non-existing item' do
          actual = described_class.find_item_by_name('foo')
          expect(actual).to be_nil
        end
        it 'returns BackpackTF::Item object for the item matching the name' do
          actual = described_class.find_item_by_name('Kritzkrieg')
          expect(actual).to eq item
        end
        it 'can return picked attributes' do
          actual = described_class.find_item_by_name('Kritzkrieg', :defindex)
          expect(actual).to eq 35
        end
        it 'returns nil when asking for attribute it does not have' do
          actual = described_class.find_item_by_name('Kritzkrieg', :foo)
          expect(actual).to be_nil
        end
      end
    end

    describe '::random_item' do
      before(:context) do
        described_class.class_eval { @items = nil }
      end
      before(:each) do
        allow(described_class).
          to receive(:items).
          and_return(items)
        described_class.class_eval { @items = items }
      end
      after(:each) do
        described_class.class_eval { @items = nil }
      end
      it 'returns a name of a BackpackTF::Item object' do
        item = described_class.random_item
        expect(described_class.items.keys.include? item).to be_truthy
      end

      context 'asking for prices property' do
        it 'returns Hash object where keys are String objects' do
          item_prices = described_class.random_item :price
          expect(item_prices.keys).to all be_a String
        end
        it 'returns Hash object where values are BackpackTF::ItemPrice objects' do
          item_prices = described_class.random_item :price
          expect(item_prices.values).to all be_a BackpackTF::ItemPrice
        end
      end
    end

    describe '#initialize' do
      it 'raises an error when trying to instantiate this class' do
        expect{ described_class.new }.to raise_error RuntimeError
      end
    end
  end
end
