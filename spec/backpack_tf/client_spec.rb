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

    end
  
    context 'Instances of Client' do
      let(:bp) { Client.new }
  
      describe '#get_data' do

        before do
          VCR.insert_cassette 'pricing_data', :record => :new_episodes
        end

        after do
          VCR.eject_cassette
        end

        xcontext 'query parameters' do
          it 'produces correct query parameter string' do
            opts = {:appid => 440, :format => 'json', :compress => 1, :raw => 2}
            stubbed = stub_request(:get, "http://backpack.tf/api/IGetCurrencies/v1/").with(:query => opts)
            expect(stubbed.request_pattern.uri_pattern.to_s).to eq "http://backpack.tf/api/IGetCurrencies/v1/?appid=440&compress=1&format=json&key=#{Client.api_key}&raw=2"
          end
        end

        xcontext 'requesting correct API endpoint' do
          it 'returns correct destination url, when asked for pricing data' do
            # setup - data
            #action = :get_prices
            #opts = { :key => Client.api_key, :compress => 1, :appid => 440 }
            # setup - expectations
            stub_request(:get, "http://backpack.tf/api/IGetCurrencies/v1/")
            # exercise
            #result = bp.get_data(action, opts)
            # verify
            expect(sr.to_s.split(' ')[1]).to eq "http://backpack.tf/api/IGetCurrencies/v1/"
          end
        end
      end

      xdescribe '#extract_query_string' do
        it 'is private, so called normally results in NoMethodError' do
          expect{bp.extract_query_string({})}.to raise_error NoMethodError
        end
        it 'produces a query parameter string' do
          opts = {:key => Client.api_key, :appid => 440, :format => 'json', :compress => 1, :raw => 2}
          ans = "key=#{Client.api_key}&appid=440&format=json&compress=1&raw=2"
          expect(bp.send(:extract_query_string, opts)).to eq ans
        end
      end

      xdescribe '#build_url_via' do
        it 'is private, so called normally results in NoMethodError' do
          expect{bp.build_url_via :get_prices}.to raise_error NoMethodError
        end
        it 'returns correct destination url when asking for pricing data' do
          opts = {:key => Client.api_key, :compress => 1}
          url = "http://backpack.tf/api/IGetPrices/v4/?key=#{Client.api_key}&compress=1"
          expect(bp.send(:build_url_via, :get_prices, opts)).to eq url
        end
        it 'returns correct destination url when asking for currency data' do
          opts = {:key => Client.api_key, :appid => 440, :compress => 1}
          url = "http://backpack.tf/api/IGetCurrencies/v1/?key=#{Client.api_key}&appid=440&compress=1"
          expect(bp.send(:build_url_via, :get_currencies, opts)).to eq url
        end
        it 'returns correct destination url when asking for special items data' do
          opts = {:key => Client.api_key, :appid => 440, :compress => 1}
          url = "http://backpack.tf/api/IGetSpecialItems/v1/?key=#{Client.api_key}&appid=440&compress=1"
          expect(bp.send(:build_url_via, :get_special_items, opts)).to eq url
        end
        it 'returns correct destination url when asking for users data' do
          opts = {:steamids => ['76561198012598620', '76561197960869319', '76561198130699910']}
          url = "http://backpack.tf/api/IGetUsers/v3/?steamids=76561198012598620,76561197960869319,76561198130699910"
          expect(bp.send(:build_url_via, :get_users, opts)).to eq url
        end
        it 'returns correct destination url when asking for user listings data' do
          opts = {:key => Client.api_key, :steamid => '76561197960869319'}
          url = "http://backpack.tf/api/IGetUserListings/v1/?key=#{Client.api_key}&steamid=76561197960869319"
          expect(bp.send(:build_url_via, :get_user_listings, opts)).to eq url
        end
        it 'raises an error when asking for any other data' do
          expect{bp.send(:build_url_via, :foo)}.to raise_error ArgumentError
        end
      end  

      describe 'client requests' do
        before do
          VCR.insert_cassette 'pricing_data', :record => :new_episodes
        end

        after do
          VCR.eject_cassette
        end

        it 'client requests are returned as ruby Hash objects' do

          opts = {:app_id => 440, :compress => 1}
          stub_request(:get, "http://backpack.tf/api/IGetPrices/v4/").with(:query => opts).to_return(:status => 200, :body => '', :headers => {})
          expect(bp.get_data(:get_prices, opts)).to be_instance_of Hash
        end

      end

    end
  end
end
