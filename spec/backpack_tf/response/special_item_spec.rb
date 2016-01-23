require 'spec_helper'

describe BackpackTF::SpecialItem::Response do
  let(:json_response) {
    fixture = file_fixture('special_items.json')
    JSON.parse(fixture)['response']
  }

  describe '::items' do
    before(:each) do
      described_class.response = json_response
    end
    after(:each) do
      described_class.response = nil
    end

    it 'has these 2 keys' do
      actual_keys = described_class.items.keys
      expected_keys = [':weed:', 'Random Craft Hat']
      expect(actual_keys).to match_array expected_keys
    end
    it 'each key points to an instance of BackpackTF::SpecialItem' do
      expect(described_class.items.values).to all be_a BackpackTF::SpecialItem
    end
  end
end
