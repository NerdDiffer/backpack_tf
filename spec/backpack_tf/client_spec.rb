require 'spec_helper'

describe BackpackTF::Client do
  let(:bp) { BackpackTF::Client.new }

  describe('HTTParty settings') do
    before(:each) do
      BackpackTF::Client.default_params(key: 'fake_api_key')
    end
    after(:each) do
      BackpackTF::Client.default_params(key: nil)
      expect(BackpackTF::Client.default_options[:default_params][:key]).to be_nil
    end

    it 'needs to have some default_options' do
      expect(BackpackTF::Client.default_options[:base_uri]).not_to be_nil
      expect(BackpackTF::Client.default_options[:timeout]).not_to be_nil
      expect(BackpackTF::Client.default_options[:default_params][:key]).not_to be_nil
    end
  end

  describe '::api_key' do
    context('without a key') do
      it 'gently reminds user to set an API key' do
        expect(BackpackTF::Client).to receive(:warn)
        BackpackTF::Client.api_key
      end
    end
    context('validating a key') do
      it 'Raises ArgumentError, if key is not a hexadecimal string' do
        fake_key = 'abcdefghijklmnopqrstuvwx'
        expect{ BackpackTF::Client.api_key(fake_key) }.to raise_error ArgumentError
      end
      it 'Raises ArgumentError, if key is not 24 digits long' do
        fake_key = 'abcdef0987654321'
        expect{ BackpackTF::Client.api_key(fake_key) }.to raise_error ArgumentError
      end
    end
    context('confirming a key') do
      it 'lets an otherwise theoretically-valid key, pass through' do
        key = generate_fake_api_key
        expect(BackpackTF::Client.api_key(key)).to eq key
      end
    end
  end
  describe '::extract_query_string' do
    before(:each) do
      allow(BackpackTF::Client).to receive(:warn).and_return true
    end
    it 'produces a query parameter string' do
      opts = {
        key: BackpackTF::Client.api_key,
        appid: 440,
        format: 'json',
        compress: 1,
        raw: 2
      }

      expected = "key=#{BackpackTF::Client.api_key}&appid=440&format=json&compress=1&raw=2"
      expect(BackpackTF::Client.extract_query_string(opts)).to eq expected
    end
  end
  describe '::build_url_via' do
    before(:each) do
      allow(BackpackTF::Client).to receive(:warn).and_return true
    end
    it 'returns correct destination url when asking for pricing data' do
      query_opts = {
        :key => BackpackTF::Client.api_key,
        :compress => 1
      }

      actual = BackpackTF::Client.build_url_via(:get_prices, query_opts)
      expected = "http://backpack.tf/api/IGetPrices/v4/?key=#{BackpackTF::Client.api_key}&compress=1"
      expect(actual).to eq expected
    end
  end

  describe '#fetch' do
    before :each do
      stub_http_response_with('currencies.json')
    end
    it 'fetches JSON from an interface and returns a response' do
      response = bp.fetch(:currencies, {:compress => 1, :appid => 440})
      response.keys.all? do |key|
        expect(response[key]).not_to be_nil
      end
    end
  end
end
