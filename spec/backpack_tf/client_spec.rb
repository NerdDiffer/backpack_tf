require 'spec_helper'

describe BackpackTF::Client do
  let(:key) { 'deadbeef01234567deadbeef' }
  let(:bp) { BackpackTF::Client.new(key) }

  describe '#initialize' do
    it 'sets a value for @key' do
      client = described_class.new(key)
      expect( client.instance_eval{ @key }).to eq 'deadbeef01234567deadbeef'
    end
    it 'creates an instance of BackpackTF::Client' do
      client = described_class.new(key)
      expect(client).to be_an_instance_of(described_class)
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

  describe('#httparty_settings') do
    before(:each) do
      bp.instance_eval { @key = 'foo' }
    end
    after(:each) do
      bp.instance_eval { @key = nil }
    end

    it 'sets some default_options for HTTParty' do
      bp.send(:httparty_settings)

      actual = described_class.default_options
      expect(actual[:base_uri]).not_to be_nil
      expect(actual[:timeout]).not_to be_nil
      expect(actual[:default_params][:key]).not_to be_nil
    end
  end

  describe '#check_key' do
    context('without a key') do
      it 'gently reminds user to set an API key' do
        expect(bp).to receive(:warn)
        bp.send(:check_key)
      end
    end
    context('checking a key') do
      it 'Raises ArgumentError, if key is not a hexadecimal string' do
        fake_key = 'abcdefghijklmnopqrstuvwx'
        expect{ bp.send(:check_key, fake_key) }.to raise_error ArgumentError
      end
      it 'Raises ArgumentError, if key is not 24 digits long' do
        fake_key = 'abcdef0987654321'
        expect{ bp.send(:check_key, fake_key) }.to raise_error ArgumentError
      end
      it 'lets an otherwise theoretically-valid key pass through' do
        key = generate_fake_api_key
        expect(bp.send(:check_key, key)).to eq key
      end
    end
  end

  describe '#build_url_via' do
    before(:each) do
      allow(bp).to receive(:warn).and_return true
    end

    it 'returns correct destination url when asking for pricing data' do
      query_opts = {
        :key => key,
        :compress => 1
      }

      actual = bp.send(:build_url_via, :prices, query_opts)
      expected = "http://backpack.tf/api/IGetPrices/v4/?key=#{key}&compress=1"

      expect(actual).to eq expected
    end
  end

  describe '#extract_query_string' do
    before(:each) do
      allow(bp).to receive(:warn).and_return true
    end

    it 'produces a query parameter string' do
      opts = {
        key: key,
        appid: 440,
        format: 'json',
        compress: 1,
        raw: 2
      }

      expected = "key=#{key}&appid=440&format=json&compress=1&raw=2"
      expect(bp.send(:extract_query_string, opts)).to eq expected
    end
  end
end
