require 'spec_helper'

describe BackpackTF::MarketPrice::Response do
  let(:json_response) do
    fixture = file_fixture('market_prices.json')
    JSON.parse(fixture)['response']
  end

  describe '::items' do
    before(:each) do
      described_class.response = json_response
    end
    after(:each) do
      described_class.response = nil
    end

    it 'each key points to a BackpackTF::MarketPrice object' do
      items = described_class.items
      expect(items.values).to all be_a BackpackTF::MarketPrice
    end
  end
end
