require 'spec_helper'

describe BackpackTF::UserListing::Interface do
  it 'has these default attributes' do
    expect(described_class.name).to eq :IGetUserListings
    expect(described_class.version).to eq 2
    expect(described_class.steamid).to eq nil
  end
  describe '::defaults' do
    after(:each) do
      described_class.class_eval { @steamid = nil }
    end

    it 'can modify its values' do
      options = { steamid: 1 }
      described_class.defaults(options)
      expect(described_class.steamid).to eq 1
    end
  end
end
