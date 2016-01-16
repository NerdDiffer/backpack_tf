require 'spec_helper'

describe BackpackTF::Currency do
  let(:json_response) {
    fixture = file_fixture('currencies_updated.json')
    JSON.parse(fixture)['response']
  }

  it 'class has these default attributes' do
    expect(described_class.interface).to eq :IGetCurrencies
  end

  describe '::response' do
    it 'the keys of the response attribute should have these values' do
      responses_collection = { :'BackpackTF::Currency' => json_response }

      allow(described_class).
        to receive(:to_sym).
        and_return(:'BackpackTF::Currency')
      expect(described_class).
        to receive(:to_sym)
      allow(BackpackTF::Response).
        to receive(:responses).
        and_return(responses_collection)
      expect(BackpackTF::Response).
        to receive(:responses)

      response = described_class.response
      expect(response['success']).to eq 1
      expect(response['message']).to eq nil
      expect(response['current_time']).to eq 1430988840
      expect(response['name']).to eq 'Team Fortress 2'
      expect(response['url']).to eq 'http://backpack.tf'
    end
  end

  describe '::currencies' do
    it 'the @currencies variable should have these keys' do
      response = json_response
      allow(described_class).
        to receive(:response).
        and_return(response)

      currencies = described_class.currencies
      expected_keys = %w(metal keys earbuds hat)
      expect(currencies.keys).to match_array expected_keys
    end
  end

  describe '#initialize' do
    it 'instance should have these values' do
      currencies = json_response
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

      allow_any_instance_of(described_class).
        to receive(:check_attr_keys).
        and_return(processed_currencies)

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
