require 'spec_helper'

describe BackpackTF::Price::ItemPrice do
  let(:item_price) do
    key = 'Unique_Tradable_Craftable'
    described_class.new(key, {})
  end

  describe '::quality_name_to_index' do
    before(:each) do
      allow(described_class).to receive(:qualities).and_return([:foo, :bar])
    end

    it 'returns index of the quality' do
      actual = described_class.quality_name_to_index(:bar)
      expect(actual).to eq 1
    end
  end

  describe '#split_key' do
    it 'splits the string by the underscore' do
      actual = item_price.send(:split_key, 'foo_bar_quux')
      expected = %w(foo bar quux)
      expect(actual).to eq expected
    end
  end

  describe '#currency_or_nil' do
    it 'returns nil when key is not present' do
      attr = { 'foo' => 'bar' }
      actual = item_price.send(:currency_or_nil, attr)
      expect(actual).to be_nil
    end

    it 'otherwise returns values as a symbol' do
      attr = { 'currency' => 'foo' }
      actual = item_price.send(:currency_or_nil, attr)
      expect(actual).to eq :foo
    end
  end

  describe '#pick_particle_effect' do
    it 'calls ParticleEffect.list' do
      expect(BackpackTF::Price::ParticleEffect)
        .to receive(:list)
        .and_return([:foo, :bar])
        .at_most(:twice)
      item_price.send(:pick_particle_effect, '0')
    end
  end

  describe 'A price for a typical item' do
    item_price_attr = JSON.parse(file_fixture('item_price_typical.json'))

    subject do
      described_class.new('Unique_Tradable_Craftable', item_price_attr)
    end

    context 'item-specific tests' do
      it 'should have these values' do
        expect(subject.quality).to eq :Unique
        expect(subject.tradability).to eq :Tradable
        expect(subject.craftability).to eq :Craftable
        expect(subject.currency).to eq :metal
        expect(subject.value).to eq 0.05
        expect(subject.value_high).to be_nil
        expect(subject.value_raw).to be_nil
        expect(subject.value_high_raw).to be_nil
        expect(subject.last_update).to eq 1_336_410_088
        expect(subject.difference).to eq 0
        expect(subject.priceindex).to be_nil
        expect(subject.effect).to be_nil
      end
    end
  end

  describe "A price for an item with 'Unusual' quality" do
    item_price_attr = JSON.parse(file_fixture('item_price_unusual.json'))

    subject do
      described_class.new('Unusual_Tradable_Craftable', item_price_attr, 6)
    end

    context 'item-specific tests' do
      it 'should have these values' do
        expect(subject.quality).to eq :Unusual
        expect(subject.tradability).to eq :Tradable
        expect(subject.craftability).to eq :Craftable
        expect(subject.currency).to eq :keys
        expect(subject.value).to eq 18
        expect(subject.value_high).to eq 22
        expect(subject.value_raw).to be_nil
        expect(subject.value_high_raw).to be_nil
        expect(subject.last_update).to eq 1_418_795_322
        expect(subject.difference).to eq 280
        expect(subject.priceindex).to eq 6
        expect(subject.effect).to eq 'Green Confetti'
      end
    end
  end
end
