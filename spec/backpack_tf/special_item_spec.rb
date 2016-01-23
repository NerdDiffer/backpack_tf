require 'spec_helper'

describe BackpackTF::SpecialItem do
  let(:json_response) {
    fixture = file_fixture('special_items.json')
    JSON.parse(fixture)['response']
  }
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
