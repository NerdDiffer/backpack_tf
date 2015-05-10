require 'spec_helper'

module BackpackTF
  describe UserListing do
    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('user_listing.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetUserListings
    end

    it 'an instance has these attributes' do
      some_json = JSON.parse(file_fixture 'user_listing.json')['response']['listings'][0]
      listing = described_class.new(some_json)
      expected_item = {:id=>3701558065, :original_id=>3682615727, :defindex=>5042, :level=>5, :quality=>6, :inventory=>2147484348, :quantity=>1, :origin=>2, :attributes=>[{:defindex=>195, :value=>1065353216, :float_value=>1}, {:defindex=>2046, :value=>1065353216, :float_value=>1}]}
      expect(listing).to have_attributes(
        :id => :'440_3701558065',
        :bump => 1431107557,
        :created => 1429875049,
        :currencies => { 'keys' => 1 },
        :item => expected_item,
        :details => "or 1,33 key in items (no paints,parts etc.); got more in stock :) add me, send TO or use my 24\/7 http:\/\/dispenser.tf\/id\/76561197978210095",
        :meta => {:class => 'multi', :slot => 'tool', :craft_material_type => 'tool'},
        :buyout => 1,
      )
    end

    describe '::response' do
      before :all do
        expect(described_class.response).to be_nil
      end

      before :each do
        stub_http_response_with('user_listing.json')
        opts = { :compress => 1, :steamid => 76561197978210095 }
        fetched_listings = bp.fetch(:user_listings, opts)
        Response.responses(described_class.to_sym => fetched_listings)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
        expect(described_class.listings).to be_nil
      end

      it 'the keys of the response attribute should have these values' do
        expect(described_class.response[:success]).to eq 1
        expect(described_class.response[:message]).to eq nil
        expect(described_class.response[:current_time]).to eq 1431120247
      end
    end

    describe '::listings' do
      before :all do
        expect(described_class.response).to be_nil
        expect(described_class.listings).to be_nil
      end

      before :each do
        stub_http_response_with('user_listing.json')
        opts = { :compress => 1, :steamid => 76561197978210095 }
        fetched_listings = bp.fetch(:user_listings, opts)
        Response.responses(described_class.to_sym => fetched_listings)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @listings = nil }
      end

      it 'returns the fixture and sets to @@listings variable' do
        expect(described_class.listings).not_to be_nil
      end
      it 'is an Array object' do
        expect(described_class.listings).to be_instance_of Array
      end
      it 'each entry is an instance of UserListing' do
        expect(described_class.listings).to all be_a described_class
      end
    end

  end
end
