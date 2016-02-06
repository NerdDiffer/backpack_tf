require 'spec_helper'

describe BackpackTF::Price::Item do
  let(:attr) do
    { 'prices' => {}, 'defindex' => ['1'] }
  end
  let(:item) do
    described_class.new('item', attr)
  end
  let(:item_price) do
    BackpackTF::Price::ItemPrice.new('q_t_c', {})
  end

  describe '#process_defindex' do
    after(:each) do
      attr['defindex'] = nil
    end

    it 'returns nil when arr length is 0' do
      attr['defindex'] = []
      actual = item.send(:process_defindex, attr['defindex'])
      expect(actual).to be_nil
    end

    it 'returns value when arr length is 1' do
      attr['defindex'] = ['bar']
      actual = item.send(:process_defindex, attr['defindex'])
      expect(actual).to eq 'bar'
    end

    it 'otherwise returns array' do
      attr['defindex'] = %w(bar quux)
      actual = item.send(:process_defindex, attr['defindex'])
      expect(actual).to eq %w(bar quux)
    end
  end

  describe '#generate_prices_hash' do
    context 'a typical item' do
      it 'calls build_item_price' do
        mock_input_hash = {
          'prices' => {
            '6' => {
              'Tradable' => {
                'Craftable' => {
                  '0' => {}
                }
              }
            }
          }
        }
        expect(item).to receive(:build_item_price)
        item.send(:generate_prices_hash, mock_input_hash)
      end
    end

    context 'an item with "Unusual" quality' do
      it 'calls build_unusual_item_price' do
        mock_input_hash = {
          'prices' => {
            '5' => {
              'Tradable' => {
                'Craftable' => {
                  '1' => {}
                }
              }
            }
          }
        }
        expect(item).to receive(:build_unusual_item_price)
        item.send(:generate_prices_hash, mock_input_hash)
      end
    end

    context 'a crate' do
      it 'calls build_crate_price' do
        mock_input_hash = {
          'prices' => {
            '6' => {
              'Tradable' => {
                'Craftable' => {
                  '2' => {}
                }
              }
            }
          }
        }
        expect(item).to receive(:build_crate_price)
        item.send(:generate_prices_hash, mock_input_hash)
      end
    end
  end

  describe '#quality_index_to_name' do
    it 'calls ItemPrice.quality_index_to_name' do
      expect(BackpackTF::Price::ItemPrice)
        .to receive(:qualities)
        .and_return([:foo, :bar])
      item.send(:quality_index_to_name, '1')
    end
  end

  describe '#keyname' do
    before(:each) do
      expect(item).to receive(:quality_index_to_name).and_return('Quality')
    end
    it 'returns a string delimited by underscore' do
      actual = item.send(:keyname, 1, 'Tradability', 'Craftability')
      expected = 'Quality_Tradability_Craftability'
      expect(actual).to eq expected
    end

    it 'returns a string plus priceindex, delimited by underscore' do
      actual = item.send(:keyname, 1, 'Tradability', 'Craftability', '5')
      expected = 'Quality_Tradability_Craftability_#5'
      expect(actual).to eq expected
    end
  end

  describe '#build_item_price' do
    before(:each) do
      allow(BackpackTF::Price::ItemPrice)
        .to receive(:new)
        .and_return(item_price)
    end

    it 'calls for a new ItemPrice object' do
      expect(BackpackTF::Price::ItemPrice).to receive(:new)
      item.send(:build_item_price, {}, 'key_str', :attr)
    end
    it 'the new item is an ItemPrice object' do
      actual = item.send(:build_item_price, {}, 'key_str', :attr)
      expect(actual['key_str']).to be_a BackpackTF::Price::ItemPrice
    end
  end

  describe '#build_unusual_item_price' do
    before(:each) do
      expect(BackpackTF::Price::ItemPrice)
        .to receive(:new)
        .and_return(item_price)
      allow_any_instance_of(BackpackTF::Price::ItemPrice)
        .to receive(:effect)
        .and_return('effect')
    end

    it 'calls for a new ItemPrice object' do
      item.send(:build_unusual_item_price, {}, 'q_t_c', :attr, :price_idx)
    end
    it 'the name of the new key is the effect name of item price object' do
      actual = item.send(:build_unusual_item_price, {}, 'q_t_c', :attr, '5')
      expect(actual['effect']).to be_a BackpackTF::Price::ItemPrice
    end
  end

  describe '#build_crate_price' do
    before(:each) do
      allow(BackpackTF::Price::ItemPrice)
        .to receive(:new)
        .and_return(item_price)
    end

    it 'calls for a new ItemPrice object' do
      expect(BackpackTF::Price::ItemPrice).to receive(:new)
      item.send(:build_crate_price, {}, 'key_str', :attr, '85')
    end
    it 'the new item is an ItemPrice object' do
      actual = item.send(:build_crate_price, {}, 'key_str', :attr, '85')
      expect(actual['key_str']).to be_a BackpackTF::Price::ItemPrice
    end
  end

  shared_examples 'a common item' do |passed_item_attr|
    describe '#generate_prices_hash' do
      let(:prices_hash) do
        subject.send(:generate_prices_hash, passed_item_attr)
      end

      it 'each key is a String' do
        expect(prices_hash.keys).to all be_a String
      end
      it 'value of each key is a BackpackTF::ItemPrice object' do
        expect(prices_hash.values).to all be_an BackpackTF::Price::ItemPrice
      end
    end

    describe 'the @prices instance variable' do
      it 'is a Hash' do
        expect(subject.prices).to be_a Hash
      end
      it 'each value is a BackpackTF::ItemPrice object' do
        expect(subject.prices.values).to all be_an BackpackTF::Price::ItemPrice
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
      it '@prices should have these keys' do
        expected = ['Strange_Tradable_Craftable',
                    "Collector's_Tradable_Craftable",
                    'Vintage_Tradable_Craftable',
                    'Unique_Tradable_Craftable',
                    'Unique_Tradable_Non-Craftable']
        expect(subject.prices.keys).to match_array expected
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
        priceindex_vals = ['Aces High', 'Amaranthine', 'Anti-Freeze', 'Blizzardy Storm', 'Bubbling', 'Burning Flames', 'Circling Heart', 'Circling TF Logo', 'Cloud 9', 'Dead Presidents', 'Death at Dusk', 'Disco Beat Down', 'Electrostatic', 'Green Black Hole', 'Green Confetti', 'Green Energy', 'Haunted Ghosts', 'Kill-a-Watt', 'Memory Leak', 'Miami Nights', 'Molten Mallard', 'Morning Glory', "Nuts n' Bolts", 'Orbiting Fire', 'Orbiting Planets', 'Overclocked', 'Phosphorous', 'Power Surge', 'Purple Confetti', 'Purple Energy', 'Roboactive', 'Scorching Flames', 'Smoking', 'Something Burning This Way Comes', 'Steaming', 'Stormy Storm', 'Sulphurous', 'Terror-Watt', 'The Ooze', 'Time Warp', 'Unique_Tradable_Craftable']
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
        expected_defindexes = [5734, 5735, 5742, 5752, 5781, 5802, 5803]
        expect(subject.defindex).to match_array expected_defindexes
      end
      it 'prices array should have these keys' do
        expected_keys = ['Unique_Tradable_Craftable_#82',
                         'Unique_Tradable_Craftable_#83',
                         'Unique_Tradable_Craftable_#84',
                         'Unique_Tradable_Craftable_#85',
                         'Unique_Tradable_Craftable_#90',
                         'Unique_Tradable_Craftable_#91',
                         'Unique_Tradable_Craftable_#92']
        expect(subject.prices.keys).to match_array expected_keys
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

  describe 'An item with Tradable, Non-Tradable & Craftable, Non-Craftable' do
    item_attr = JSON.parse(file_fixture('item_with_dual_craftability_tradability.json'))['All-Father']
    subject { described_class.new('All-Father', item_attr) }

    context 'item-specific tests' do
      it '@prices hash has these keys' do
        expected = ['Strange_Tradable_Craftable',
                    'Strange_Tradable_Non-Craftable',
                    'Strange_Non-Tradable_Craftable',
                    'Unique_Tradable_Craftable',
                    'Unique_Tradable_Non-Craftable']
        expect(subject.prices.keys).to match_array expected
      end
    end
  end
end
