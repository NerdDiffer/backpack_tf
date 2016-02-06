require 'spec_helper'

describe BackpackTF::User::Interface do
  it 'has these default attributes' do
    expect(described_class.name).to eq :IGetUsers
    expect(described_class.version).to eq 3
    expect(described_class.steamids).to eq nil
  end
  describe '::defaults' do
    after(:each) do
      described_class.class_eval { @steamids = nil }
    end

    it 'can modify its values' do
      options = { steamids: [1, 2, 3] }
      described_class.defaults(options)
      expect(described_class.steamids).to eq [1, 2, 3]
    end
  end
end
