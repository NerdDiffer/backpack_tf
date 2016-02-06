require 'spec_helper'

describe BackpackTF::Client do
  let(:key) { 'deadbeef01234567deadbeef' }
  let(:bp) { BackpackTF::Client.new(key) }

  describe '#initialize' do
    it 'calls #check_key' do
      expect_any_instance_of(described_class).to receive(:check_key)
      described_class.new(key)
    end
    it 'sets a value for @key' do
      client = described_class.new(key)
      expect(client.instance_eval { @key }).to eq 'deadbeef01234567deadbeef'
    end
    it 'calls #httparty_settings' do
      expect_any_instance_of(described_class).to receive(:httparty_settings)
      described_class.new(key)
    end
  end

  describe '#fetch' do
    it 'calls #get_data' do
      mock_response = { 'response' => nil }
      expect(bp).to receive(:get_data).and_return(mock_response)
      bp.fetch(:foo)
    end
    it 'fetches JSON from an interface and returns a response' do
      stub_http_response_with('currencies.json')
      response = bp.fetch(:currencies, compress: 1, appid: 440)
      response.keys.all? do |key|
        expect(response[key]).not_to be_nil
      end
    end
  end

  describe '#get_data' do
    it 'calls #handle_timeout' do
      allow(described_class).to receive(:get).and_return('get')
      allow(bp).to receive(:build_url_via).and_return('url')
      expect(bp).to receive(:handle_timeouts)
      bp.send(:get_data, :foo)
    end
    it 'calls #build_url_via' do
      allow(described_class).to receive(:get).and_return('get')
      expect(bp).to receive(:build_url_via).and_return('url')
      bp.send(:get_data, :foo)
    end
    it 'calls HTTParty.get' do
      allow(bp).to receive(:build_url_via).and_return('url')
      expect(described_class).to receive(:get)
      bp.send(:get_data, :foo)
    end
  end

  describe 'handle_timeouts' do
    specify do
      expect { |mtd| bp.send(:handle_timeouts, &mtd) }.to yield_control
    end
    it 'rescues on Net::OpenTimeout or Net::ReadTimeout exceptions' do
      bp.send(:handle_timeouts) { raise Net::OpenTimeout }
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
        expect { bp.send(:check_key, fake_key) }.to raise_error ArgumentError
      end
      it 'Raises ArgumentError, if key is not 24 digits long' do
        fake_key = 'abcdef0987654321'
        expect { bp.send(:check_key, fake_key) }.to raise_error ArgumentError
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
        key: key,
        compress: 1
      }

      actual = bp.send(:build_url_via, :prices, query_opts)
      expected = "http://backpack.tf/api/IGetPrices/v4/?key=#{key}&compress=1"

      expect(actual).to eq expected
    end
  end

  describe '#extract_query_string' do
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
    it 'separates array values by comma' do
      opts = {
        steamids: %w(1 2 3)
      }

      expected = 'steamids=1,2,3'
      expect(bp.send(:extract_query_string, opts)).to eq expected
    end
  end

  describe '#select_interface_url_fragment' do
    context 'verifying API base urls' do
      it 'gets it right for IGetCurrencies' do
        actual = bp.send(:select_interface_url_fragment, :currencies)
        expect(actual).to eq '/IGetCurrencies/v1/?'
      end
      it 'gets it right for IGetMarketPrices' do
        actual = bp.send(:select_interface_url_fragment, :market_prices)
        expect(actual).to eq '/IGetMarketPrices/v1/?'
      end
      it 'gets it right for IGetPrices' do
        actual = bp.send(:select_interface_url_fragment, :prices)
        expect(actual).to eq '/IGetPrices/v4/?'
      end
      it 'gets it right for IGetPriceHistory' do
        actual = bp.send(:select_interface_url_fragment, :price_history)
        expect(actual).to eq '/IGetPriceHistory/v1/?'
      end
      it 'gets it right for IGetSpecialItems' do
        actual = bp.send(:select_interface_url_fragment, :special_items)
        expect(actual).to eq '/IGetSpecialItems/v1/?'
      end
      it 'gets it right for IGetUsers' do
        actual = bp.send(:select_interface_url_fragment, :users)
        expect(actual).to eq '/IGetUsers/v3/?'
      end
      it 'gets it right for IGetUserListings' do
        actual = bp.send(:select_interface_url_fragment, :user_listings)
        expect(actual).to eq '/IGetUserListings/v2/?'
      end
    end
    it 'returns nil when it cannot match to an action' do
      actual = bp.send(:select_interface_url_fragment, :foobar)
      expect(actual).to be_nil
    end
  end
end
