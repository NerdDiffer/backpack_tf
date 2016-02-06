require 'spec_helper'

describe BackpackTF::Price::ParticleEffect do
  describe '::read_stored_effects_info' do
    it 'creates a key value pair for each id & name' do
      expect(described_class.read_stored_effects_info[17]).to eq 'Sunbeams'
      expect(described_class.read_stored_effects_info[5]).to eq 'Holy Glow'
    end
    it 'is nil if it cannot find that key' do
      expect(described_class.read_stored_effects_info[nil]).to be_nil
    end

    context '@list' do
      it 'same thing can be accessed through class variable' do
        expect(described_class.list[17]).to eq 'Sunbeams'
        expect(described_class.list[5]).to eq 'Holy Glow'
      end
      it 'is nil if it cannot find that key' do
        expect(described_class.list[nil]).to be_nil
      end
    end
  end
end
