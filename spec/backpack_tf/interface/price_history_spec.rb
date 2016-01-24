require 'spec_helper'

describe BackpackTF::PriceHistory::Interface do
  it 'has these default attributes' do
    expect(described_class.name).to eq :IGetPriceHistory
    expect(described_class.version).to eq 1
    expect(described_class.item).to eq nil
    expect(described_class.quality).to eq nil
    expect(described_class.tradable).to eq nil
    expect(described_class.craftable).to eq nil
    expect(described_class.priceindex).to eq nil
  end
  describe '::defaults' do
    after(:each) do
      described_class.class_eval do
        @item = nil
        @quality = nil
        @tradable = nil
        @craftable = nil
        @priceindex = nil
      end
    end
    it 'can modify its values' do
      options = {
        item: 'item name or defindex',
        quality: 'quality name or defindex',
        tradable: 1,
        craftable: 1,
        priceindex: 0,
      }
      described_class.defaults(options)
      %i(@item @quality @tradable @craftable @priceindex).each do |ivar|
        expect(described_class.instance_variable_get(ivar)).not_to be_nil
      end
    end
  end
end
