require 'spec_helper'

describe BackpackTF::Currency do
  let(:currencies) do
    fixture = file_fixture('currencies_updated.json')
    JSON.parse(fixture)['response']
  end

  describe '#initialize' do
    it 'instance should have these values' do
      processed_currencies = {
        quality: 6,
        priceindex: 0,
        single: 'ref',
        plural: 'ref',
        round: '2',
        craftable: 'Craftable',
        tradable: 'Tradable',
        defindex: 5002,
        blanket: 0
      }

      allow_any_instance_of(described_class)
        .to receive(:hash_keys_to_sym)
        .and_return(processed_currencies)

      subject = described_class.new(:metal, currencies['metal'])

      expect(subject).to have_attributes(
        quality: 6,
        priceindex: 0,
        single: 'ref',
        plural: 'ref',
        round: '2',
        craftable: :Craftable,
        tradable: :Tradable,
        defindex: 5002,
        blanket: 0
      )
    end
  end
end
