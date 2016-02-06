require 'spec_helper'

describe BackpackTF::Price::Response do
  let(:response) do
    {
      'raw_usd_value' => 'raw_usd_value',
      'usd_currency' => 'usd_currency',
      'usd_currency_index' => 'usd_currency_index'
    }
  end

  context 'reader methods' do
    before(:each) do
      described_class.response = response
    end
    after(:each) do
      described_class.response = nil
    end

    describe '::raw_usd_value' do
      it 'returns the value' do
        expect(described_class.raw_usd_value).to eq 'raw_usd_value'
      end
    end

    describe '::usd_currency' do
      it 'returns the value' do
        expect(described_class.usd_currency).to eq 'usd_currency'
      end
    end

    describe '::usd_currency_index' do
      it 'returns the value' do
        expect(described_class.usd_currency_index).to eq 'usd_currency_index'
      end
    end

    describe '::items' do
      after :each do
        described_class.class_eval { @items = nil }
      end
      context 'when @items is not nil' do
        before :each do
          described_class.class_eval { @items = { foo: 'bar' } }
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
  end

  describe '::generate_items' do
    let(:json_response) do
      fixture = file_fixture('prices.json')
      JSON.parse(fixture)['response']
    end

    context 'using keys to generate BackpackTF::Item objects' do
      before(:each) do
        described_class.response = json_response
      end
      after(:each) do
        described_class.response = nil
      end
      it 'each value of hash is a BackpackTF::Price::Item object' do
        actual = described_class.generate_items.values
        expect(actual).to all be_a BackpackTF::Price::Item
      end
      it 'if an item does not have a valid `defindex`, then it is ignored' do
        generated_items = described_class.generate_items
        expect(generated_items['Random Craft Hat']).to be_nil
      end
    end
  end
end
