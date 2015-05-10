require 'spec_helper'

module BackpackTF
  describe 'Client' do
    let(:bp) { Client.new }

    it 'has these default options' do
      ans = { base_uri: 'http://backpack.tf/api', timeout: 5 }
      ans[:default_params] = { key: ENV[Client.env_var] }
      expect(Client.default_options).to eq ans
    end

    describe '::api_key' do
      it 'Raises ArgumentError, if key is not a hexadecimal string' do
        fake_key = 'abcdefghijklmnopqrstuvwx'
        expect{Client.api_key(fake_key)}.to raise_error ArgumentError
      end
      it 'Raises ArgumentError, if key is not 24 digits long' do
        fake_key = 'abcdef0987654321'
        expect{Client.api_key(fake_key)}.to raise_error ArgumentError
      end
      it 'lets an otherwise theoretically-valid key, pass through' do
        key = generate_fake_api_key
        expect(Client.api_key(key)).to eq key
      end
    end

    describe '::extract_query_string' do
      it 'produces a query parameter string' do
        opts = {:key => Client.api_key, :appid => 440, :format => 'json', :compress => 1, :raw => 2}
        ans = "key=#{Client.api_key}&appid=440&format=json&compress=1&raw=2"
        expect(Client.extract_query_string(opts)).to eq ans
      end
    end

    describe '::build_url_via' do
      it 'returns correct destination url when asking for pricing data' do
        opts = {:key => Client.api_key, :compress => 1}
        expect(Client.build_url_via(:get_prices, opts)).to eq "http://backpack.tf/api/IGetPrices/v4/?key=#{Client.api_key}&compress=1"
      end
      it 'raises an error when asking for any unexpected interface' do
        expect{Client.build_url_via(:foo)}.to raise_error ArgumentError
      end
    end  

    describe '#fetch' do

      before :each do
        stub_http_response_with('currencies.json')
      end

      let(:fetched_currencies) {
        bp.fetch(:currencies, {:compress => 1, :appid => 440})
      }

      it 'fetches JSON from an interface and returns as a Hash object' do
        expect(fetched_currencies).to be_instance_of Hash
      end
      it 'fetched response has these keys' do
        expected_keys = %w(currencies current_time name success url)
        expect(fetched_currencies.keys).to match_array expected_keys
      end

    end

    describe '#update' do
      #context "USING rspec/mock, updating another another class' class variable" do
      #  before :each do
      #    MockResponse = class_double(Response)
      #    MockCurrency = class_double(Currency)

      #    allow(MockResponse).to receive(:responses) { 
      #      { MockCurrency => fetched_currencies }
      #    }
      #    expect(MockResponse.responses.keys).to eq [MockCurrency]

      #    allow(MockCurrency).to receive(:response) {
      #      Response.hash_keys_to_sym(MockResponse.responses[MockCurrency])
      #    }
      #    expect(MockCurrency.response.keys).to eq [:success, :currencies, :name, :url, :current_time]

      #    allow(MockCurrency).to receive(:currencies)
      #    #expect(MockCurrency.response).to be_nil
      #  end

      #  it 'the client passes its fetched data to Response.response class method' do
      #  end
      #  it 'the client can pass fetched data to another class so the class can update one of its own class variables' do
      #    MockResponse.responses(MockCurrency => fetched_currencies)
      #    MockCurrency.response
      #    expect(MockCurrency.currencies).not_to be_nil
      #  end
      #end

      before :each do
        stub_http_response_with('currencies.json')
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(Currency.response).to be_nil
        expect(Currency.currencies).to be_nil
      end

      after :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(Currency.response).to be_nil
        expect(Currency.currencies).to be_nil
      end

      let(:fetched_currencies) {
        bp.fetch(:currencies, {:compress => 1, :appid => 440})
      }

      context 'results on the Currency.response method' do
        it 'returns this Hash object' do
          bp.update(Currency, fetched_currencies)
          processed_json = Response.hash_keys_to_sym(fetched_currencies)
          expect(Currency.response).to eq processed_json
        end
      end

      context 'results on the Currency.currencies method' do
        it 'returns this Hash object' do
          bp.update(Currency, fetched_currencies)
          processed_json = Response.hash_keys_to_sym(fetched_currencies['currencies'])
          expect(Currency.currencies).to eq processed_json
        end
      end

    end

  end
end
