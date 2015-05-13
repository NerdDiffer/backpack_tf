require 'spec_helper'

module BackpackTF
  describe Item do
    shared_examples 'a common item' do |passed_item_attr|
      it 'should respond to these methods' do
        expect(subject).to respond_to :item_name, :defindex, :prices, :generate_prices_hash
      end

      describe '#generate_prices_hash' do
        let(:prices_hash) { subject.generate_prices_hash(passed_item_attr) }

        it 'generates a Hash' do
          expect(prices_hash).to be_instance_of Hash
        end
        it 'each key is a String' do
          expect(prices_hash.keys).to all be_a String
        end
        it 'value of each key is an ItemPrice object' do
          expect(prices_hash.values).to all be_an ItemPrice
        end
      end

      describe 'the @prices instance variable' do
        it 'is a Hash' do
          expect(subject.prices).to be_a Hash
        end
        it 'each value is an ItemPrice object' do
          expect(subject.prices.values).to all be_an ItemPrice
        end
      end
    end

    describe 'A typical item' do
      item_attr = JSON.parse(file_fixture('item_typical.json'))['Kritzkrieg']
      item = described_class.new('Kritzkrieg', item_attr)
      subject { item }
      it_behaves_like('a common item', item_attr)

      context 'item-specific tests' do
        it 'should have these values' do
          expect(subject.item_name).to eq 'Kritzkrieg'
          expect(subject.defindex).to eq 35
        end
        xit '@prices should have these keys' do
          ans = ['Strange_Tradable_Craftable',
                 "Collector's_Tradable_Craftable",
                 'Vintage_Tradable_Craftable',
                 'Unique_Tradable_Craftable',
                 'Unique_Tradable_Non-Craftable']
          expect(subject.prices.keys).to match_array ans
        end
      end
    end

    describe "An item with the quality of 'Unusual'" do
      item_attr = JSON.parse(file_fixture('item_unusual.json'))['Barnstormer']
      item = described_class.new('Barnstormer', item_attr)
      subject { item }
      it_behaves_like('a common item', item_attr)

      context 'item-specific tests' do
        it 'should have these values' do
          expect(item.item_name).to eq 'Barnstormer'
          expect(item.defindex).to eq 988
        end
        it '@prices should have these keys' do
          priceindex_vals = ["Aces High", "Anti-Freeze", "Blizzardy Storm", "Bubbling", "Burning Flames", "Circling Heart", "Circling TF Logo", "Cloud 9", "Dead Presidents", "Death at Dusk", "Disco Beat Down", "Electrostatic", "Green Black Hole", "Green Confetti", "Green Energy", "Haunted Ghosts", "Kill-a-Watt", "Memory Leak", "Miami Nights", "Morning Glory", "Nuts n' Bolts", "Orbiting Fire", "Orbiting Planets", "Overclocked", "Phosphorous", "Power Surge", "Purple Confetti", "Purple Energy", "Roboactive", "Scorching Flames", "Smoking", "Steaming", "Stormy Storm", "Sulphurous", "Terror-Watt", "Time Warp", "Unique_Tradable_Craftable"]
          expect(subject.prices.keys).to match_array priceindex_vals
        end
      end
    end

    describe 'An item with many priceindex values (Crate or Unusual)' do
      item_attr = JSON.parse(file_fixture('item_crate.json'))['Mann Co. Supply Munition']
      item = described_class.new('Mann Co. Supply Munition', item_attr)
      subject { item }
      it_behaves_like('a common item', item_attr)

      context 'item-specific tests' do
        it 'should have these values' do
          expect(subject.item_name).to eq 'Mann Co. Supply Munition'
          expect(subject.defindex).to match_array [5734, 5735, 5742, 5752, 5781, 5802, 5803]
        end
        it 'prices array should have these keys' do
          ans = ['Unique_Tradable_Craftable_#82',
                 'Unique_Tradable_Craftable_#83',
                 'Unique_Tradable_Craftable_#84',
                 'Unique_Tradable_Craftable_#85',
                 'Unique_Tradable_Craftable_#90',
                 'Unique_Tradable_Craftable_#91',
                 'Unique_Tradable_Craftable_#92']
          expect(subject.prices.keys).to match_array ans
        end
      end
    end

    describe 'An item with an unconventional structure' do
      item_attr = JSON.parse(file_fixture('item_with_unconventional_structure.json'))['Aqua Summer 2013 Cooler']
      item = described_class.new('Aqua Summer 2013 Cooler', item_attr)
      subject { item }
      it_behaves_like('a common item', item_attr)

      context 'item-specific tests' do
        it 'should have these values' do
          expect(item.item_name).to eq 'Aqua Summer 2013 Cooler'
          expect(item.defindex).to eq 5650
        end
      end
    end

    describe "An item that has a negative 'defindex' or no 'defindex' at all" do
      item_attr = JSON.parse(file_fixture('item_without_defindex.json'))['Strange Part: Fires Survived']
      item = described_class.new('Strange Part: Fires Survived', item_attr)
      subject { item }
      it_behaves_like('a common item', item_attr)

      context 'item-specific tests' do
        it 'should have these values' do
          expect(item.item_name).to eq 'Strange Part: Fires Survived'
          expect(item.defindex).to eq nil
        end
      end
    end
  end
end
