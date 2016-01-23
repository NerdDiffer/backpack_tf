require 'spec_helper'

describe BackpackTF::UserListing::Response do
  let(:json_response) {
    fixture = file_fixture('user_listing.json')
    JSON.parse(fixture)['response']
  }

  describe '::listings' do
    before(:each) do
      described_class.response = json_response
    end
    after :each do
      described_class.response = nil
    end

    it 'each entry is an instance of BackpackTF::UserListing' do
      expect(described_class.listings).to all be_a BackpackTF::UserListing
    end
  end
end
