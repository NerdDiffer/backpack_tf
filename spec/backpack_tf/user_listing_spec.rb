require 'spec_helper'

describe BackpackTF::UserListing do
  describe '#initialize' do
    it 'an instance has these attributes' do
      some_json = JSON.parse(file_fixture 'user_listing.json')['response']['listings'][0]
      listing = described_class.new(some_json)
      expected_item = {
        :id=>3701558065,
        :original_id=>3682615727,
        :defindex=>5042,
        :level=>5,
        :quality=>6,
        :inventory=>2147484348,
        :quantity=>1,
        :origin=>2,
        :attributes=>[{
          :defindex=>195,
          :value=>1065353216,
          :float_value=>1
        }, {
          :defindex=>2046,
          :value=>1065353216,
          :float_value=>1
        }]
      }
      expect(listing).to have_attributes(
        :id => :'440_3701558065',
        :bump => 1431107557,
        :created => 1429875049,
        :currencies => { 'keys' => 1 },
        :item => expected_item,
        :details => "or 1,33 key in items (no paints,parts etc.); got more in stock :) add me, send TO or use my 24\/7 http:\/\/dispenser.tf\/id\/76561197978210095",
        :meta => {
          :class => 'multi',
          :slot => 'tool',
          :craft_material_type => 'tool'
        },
        :buyout => 1,
      )
    end
  end
end
