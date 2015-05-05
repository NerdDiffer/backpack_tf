require 'spec_helper'

module BackpackTF
  describe 'Prices' do
    describe 'Prices class' do

      it 'has these default attributes' do
        expect(Prices.interface).to eq :IGetPrices
      end

      describe 'accessing the IGetPrices interface' do

        context 'a successful response' do
          it 'returns the fixture and sets to @@items variable' do
            stub_http_response_with('prices.json')
            opts = { :app_id => 440, :compress => 1 }
            Prices.fetch(Client.new.get_data(:get_prices, opts)['response'])
            expect(Prices.items).not_to be_nil
          end

          it 'the response attribute should have these keys' do
            expect(Prices.response.keys).to match_array [:success, :current_time, :raw_usd_value, :usd_currency, :usd_currency_index, :items]
          end

          it 'the keys of the response attribute should have these values' do
            expect(Prices.response[:success]).to eq 1
            expect(Prices.response[:message]).to eq nil
            expect(Prices.response[:current_time]).to eq 1430785805
            expect(Prices.response[:raw_usd_value]).to eq 0.115
            expect(Prices.response[:usd_currency]).to eq 'metal'
            expect(Prices.response[:usd_currency_index]).to eq 5002
          end

          it '@@items attribute should be a Hash object' do
            expect(Prices.items).to be_instance_of Hash
          end

          it '@@items should have this many keys' do
            expect(Prices.items.keys.length).to be 1661
          end

          it '@@items should have these keys' do
            expect(Prices.items).to have_key('Kritzkrieg')
          end

        end

      end

    end

    describe 'instances of Prices' do
      it 'for now, there are not meant to be instances of this class' do
        expect{Prices.new}.to raise_error RuntimeError
      end
    end

  end
end
