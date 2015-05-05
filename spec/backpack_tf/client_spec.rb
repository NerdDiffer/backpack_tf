require 'spec_helper'

module BackpackTF
  describe 'Client' do
    context 'The Client class' do
  
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
    end
  
    context 'Instances of Client' do
      let(:bp) { Client.new }

      describe '#get_data' do

        it 'returns results from archived json file' do
          stub_http_response_with('currencies.json')
          opts = { :key => Client.api_key, :compress => 1, :appid => 440 }
          currencies = bp.get_data(:get_currencies, opts)

          expect(currencies['response']).to have_key('success')
          expect(currencies['response']).to have_key('currencies')
          expect(currencies['response']).to have_key('name')
          expect(currencies['response']).to have_key('url')
          expect(currencies['response']).to have_key('current_time')
        end

        it 'client requests are returned as ruby Hash objects' do
          stub_http_response_with('prices.json')
          opts = {:app_id => 440, :compress => 1}
          expect(bp.get_data(:get_prices, opts)).to be_instance_of Hash
        end

      end


    end
  end
end
