require 'spec_helper'

describe BackpackTF::SpecialItem do
  let(:json_response) {
    fixture = file_fixture('special_items.json')
    JSON.parse(fixture)['response']
  }

  it 'has these default attributes' do
    expect(described_class.interface).to eq :IGetSpecialItems
  end

  describe '::response' do
    before(:each) do
      responses_collection = { :'BackpackTF::SpecialItem' => json_response }

      allow(described_class).
        to receive(:to_sym).
        and_return(:'BackpackTF::SpecialItem')
      expect(described_class).
        to receive(:to_sym)
      allow(BackpackTF::Response).
        to receive(:responses).
        and_return(responses_collection)
      expect(BackpackTF::Response).
        to receive(:responses)
    end
    after(:each) do
      described_class.class_eval { @response = nil }
      described_class.class_eval { @items = nil }
    end
    it 'the keys of the response attribute should have these values' do
      response = described_class.response
      expect(response['success']).to eq 1
      expect(response['message']).to eq nil
      expect(response['current_time']).to eq 1431108270
    end
  end

  describe '::items' do
    before(:each) do
      response = json_response
      described_class.class_eval { @response = response }
    end
    after(:each) do
      described_class.class_eval { @response = nil }
    end

    it 'has these 2 keys' do
      expected_keys = [':weed:', 'Random Craft Hat']
      expect(described_class.items.keys).to match_array expected_keys
    end
    it 'each key points to an instance of SpecialItem' do
      expect(described_class.items.values).to all be_a BackpackTF::SpecialItem
    end
  end

  describe '#initialize' do
    it 'has these attributes' do
      some_json = json_response['items'][1]
      special_item = described_class.new('Random Craft Hat', some_json)
      expect(special_item).to have_attributes(
        :name => 'Random Craft Hat',
        :item_name => 'Random Craft Hat',
        :defindex => -2,
        :item_class => 'tf_wearable',
        :item_type_name => 'Currency Item',
        :item_description => 'Any item that is considered to be a random craft hat.',
        :item_quality => 0,
        :min_ilevel => 1,
        :max_ilevel => 1,
        :image_url => "https:\/\/steamcdn-a.akamaihd.net\/apps\/440\/icons\/kit_fancyhats.bf5ba4ea973728df20402c0c9a4737f18d5d560c.png",
        :image_url_large => "https:\/\/steamcdn-a.akamaihd.net\/apps\/440\/icons\/kit_fancyhats_large.800ea1b16df707ffa27f9f6e6033e8ba3f0f5333.png",
        :appid => 440
      )
    end
  end
end
