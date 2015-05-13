require 'spec_helper'

module BackpackTF
  describe ItemPrice do

    describe '::quality_name_to_index' do
      it 'returns Quality Index of the name of Quality' do
        expect(described_class.quality_name_to_index('Strange')).to eq 11
      end
      it 'returns nil when you ask for index of `nil`' do
        expect(described_class.quality_name_to_index(nil)).to be_nil
      end
    end
    
    describe '::hash_particle_effects' do
      it 'creates a key value pair for each id & name' do
        expect(described_class.hash_particle_effects[17]).to eq 'Sunbeams'
        expect(described_class.hash_particle_effects[5]).to eq 'Holy Glow'
      end
      it 'is nil if it cannot find that key' do
        expect(described_class.hash_particle_effects[nil]).to be_nil
      end

      context '@@particle_effects' do
        it 'same thing can be accessed through class variable' do
          expect(described_class.particle_effects[17]).to eq 'Sunbeams'
          expect(described_class.particle_effects[5]).to eq 'Holy Glow'
        end
        it 'is nil if it cannot find that key' do
          expect(described_class.particle_effects[nil]).to be_nil
        end
      end
    end

    describe '#initialize' do
      base_json = JSON.parse(file_fixture('item_typical.json'))['Kritzkrieg']
      ok_json = base_json['prices']['6']['Tradable']['Craftable'][0]
      wrong_level = base_json['prices']['6']['Tradable']

      context 'validating first parameter' do

        it 'will raise ArgumentError if there is not enough information' do
          expect{described_class.new('Unique_Tradable', ok_json)}.to raise_error ArgumentError
        end
        it 'will raise NameError if any one of the info bits is incorrect' do
          expect{described_class.new('xx_Tradable_Craftable', ok_json)}.to raise_error NameError
        end
        it 'will raise a NameError if name has correct info but is out of order' do
          expect{described_class.new('Craftable_Tradable_Strange', ok_json)}.to raise_error NameError
        end
      end
      context 'validating 2nd parameter' do
        it 'will raise a KeyError if JSON does not have required keys' do
          expect{described_class.new('Unique_Tradable_Craftable', wrong_level)}.to raise_error KeyError
        end
      end
    end

    shared_examples 'an ItemPrice object' do
      it 'should respond to these methods' do
        expect(subject).to respond_to :quality, :tradability, :craftability, :priceindex, :currency, :value, :value_high, :value_raw, :value_high_raw, :last_update, :difference
      end
    end

    describe 'A price for a typical item' do
      item_price_attr = JSON.parse(file_fixture('item_typical.json'))['Kritzkrieg']['prices']['6']['Tradable']['Craftable'][0]

      subject {
        described_class.new('Unique_Tradable_Craftable', item_price_attr)
      }

      it_behaves_like('an ItemPrice object')

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
          expect(subject.last_update).to eq 1336410088
          expect(subject.difference).to eq 0
          expect(subject.priceindex).to be_nil
          expect(subject.effect).to be_nil
        end
      end
    end

    describe "A price for an item with 'Unusual' quality" do
      item_price_attr = JSON.parse(file_fixture('item_unusual.json'))['Barnstormer']['prices']['5']['Tradable']['Craftable']['6']

      subject { 
        described_class.new('Unusual_Tradable_Craftable', item_price_attr, 6)
      }

      it_behaves_like('an ItemPrice object')

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
          expect(subject.last_update).to eq 1418795322
          expect(subject.difference).to eq 280
          expect(subject.priceindex).to eq 6
          expect(subject.effect).to eq 'Green Confetti'
        end
      end
    end
  end
end
