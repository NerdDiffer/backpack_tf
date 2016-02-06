require 'spec_helper'

describe BackpackTF::Price::Interface do
  it 'has these default attributes' do
    expect(described_class.name).to eq :IGetPrices
    expect(described_class.version).to eq 4
    expect(described_class.raw).to eq nil
    expect(described_class.since).to eq nil
  end
  describe '::defaults' do
    after(:each) do
      described_class.class_eval do
        @raw = nil
        @since = nil
      end
    end
    it 'can modify its values' do
      options = {
        raw: 2,
        since: '1451606400'
      }
      described_class.defaults(options)
      expect(described_class.raw).to eq 2
      expect(described_class.since).to eq '1451606400'
    end
  end
end
