require 'spec_helper'

describe BackpackTF::PriceHistory::Response do
  let(:json_response) do
    fixture = file_fixture('price_history.json')
    JSON.parse(fixture)['response']
  end

  describe '::history' do
    before(:each) do
      described_class.response = json_response
    end
    after :each do
      described_class.response = nil
    end

    it 'each entry is a BackpackTF::PriceHistory object' do
      actual = BackpackTF::PriceHistory::Response.history
      expect(actual).to all be_a BackpackTF::PriceHistory
    end
  end
end
