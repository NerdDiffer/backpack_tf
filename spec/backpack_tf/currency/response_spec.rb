require 'spec_helper'

describe BackpackTF::Currency::Response do
  let(:json_response) do
    fixture = file_fixture('currencies_updated.json')
    JSON.parse(fixture)['response']
  end

  context 'reader methods' do
    before(:each) do
      described_class.response = json_response
    end
    after(:each) do
      described_class.response = nil
    end

    describe '::currencies' do
      it 'should have these keys' do
        currencies = described_class.currencies
        expected_keys = %w(metal keys earbuds hat)
        expect(currencies.keys).to match_array expected_keys
      end
      it 'each key points to an instance of BackpackTF::Currency' do
        currencies = described_class.currencies
        expect(currencies.values).to all be_a BackpackTF::Currency
      end
    end

    describe '::name' do
      it 'returns the value' do
        expect(described_class.name).to eq 'Team Fortress 2'
      end
    end

    describe '::url' do
      it 'returns the value' do
        expect(described_class.url).to eq 'http://backpack.tf'
      end
    end
  end
end
