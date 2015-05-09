require 'spec_helper'

module BackpackTF
  describe Item do
    shared_examples 'a common item' do |passed_item_attr|
      it 'should respond to these methods' do
        expect(subject).to respond_to :item_name, :defindex, :prices, :gen_prices_hash
      end

      describe '#gen_prices_hash' do
        let(:prices_hash) { subject.gen_prices_hash(passed_item_attr) }

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
