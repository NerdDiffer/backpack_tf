require 'spec_helper'

module BackpackTF
  describe SpecialItem do
    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('special_items.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetSpecialItems
    end

    describe '::response' do
      before :context do
        expect(described_class.response).to be_nil
      end

      before :each do
        stub_http_response_with('special_items.json')
        fetched_special_items = bp.fetch(:special_items) 
        bp.update(described_class, fetched_special_items)
      end

      after :context do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
        expect(described_class.items).to be_nil
      end

      it 'the keys of the response attribute should have these values' do
        response = described_class.response
        expect(response[:success]).to eq 1
        expect(response[:message]).to eq nil
        expect(response[:current_time]).to eq 1431108270
      end
    end

    describe '::items' do
      before :context do
        expect(described_class.response).to be_nil
        expect(described_class.items).to be_nil
      end

      before :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty

        stub_http_response_with('special_items.json')
        fetched_special_items = bp.fetch(:special_items) 
        bp.update(described_class, fetched_special_items)
      end

      after :context do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @items = nil }
      end

      it 'returns the fixture and sets to @items variable' do
        expect(described_class.items).not_to be_nil
      end

      it 'is a Hash object' do
        expect(described_class.items).to be_instance_of Hash
      end

      it 'has these 2 keys' do
        expect(described_class.items.keys).to match_array [':weed:', 'Random Craft Hat']
      end

      it 'each key points to an instance of SpecialItem' do
        expect(described_class.items.values).to all be_a BackpackTF::SpecialItem
      end
    end

    describe '#initialize' do
      let(:some_json) {
        JSON.parse(file_fixture 'special_items.json')['response']['items'][1]
      }

      it 'has these attributes' do
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
end
