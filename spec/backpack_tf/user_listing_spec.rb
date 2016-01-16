require 'spec_helper'

describe BackpackTF::UserListing do
  let(:json_response) {
    fixture = file_fixture('user_listing.json')
    JSON.parse(fixture)['response']
  }

  it 'has these default attributes' do
    expect(described_class.interface).to eq :IGetUserListings
  end

  describe '::response' do
    before(:context) do
      BackpackTF::UserListing.class_eval { @response = nil }
    end
    before :each do
      responses_collection = { :'BackpackTF::UserListing' => json_response }
      allow(described_class).
        to receive(:to_sym).
        and_return(:'BackpackTF::UserListing')
      expect(described_class).
        to receive(:to_sym)
      allow(BackpackTF::Response).
        to receive(:responses).
        and_return(responses_collection)
      expect(BackpackTF::Response).
        to receive(:responses)
    end
    after :each do
      BackpackTF::UserListing.class_eval { @response = nil }
    end

    it 'the keys of the response attribute should have these values' do
      response = described_class.response
      expect(response['success']).to eq 1
      expect(response['message']).to eq nil
      expect(response['current_time']).to eq 1431120247
    end
  end

  describe '::listings' do
    before(:each) do
      response = json_response
      described_class.class_eval { @response = response }
    end
    after :each do
      BackpackTF::User.class_eval { @response = nil }
    end

    it 'each entry is an instance of BackpackTF::UserListing' do
      expect(described_class.listings).to all be_a described_class
    end
  end

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
