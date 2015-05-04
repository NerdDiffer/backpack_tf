require 'spec_helper'

module BackpackTF
  describe 'Currencies' do
    let(:bp) { Client.new }

    describe 'the class' do

      describe 'accessing the IGetCurrencies interface' do

        context 'a successful response' do
          before do
            VCR.insert_cassette 'currency_data', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'records the fixture' do
            opts = { :app_id => 440, :compress => 1 }
            Currencies.fetch(bp.get_data(:get_currencies, opts))
          end

          it 'the response attribute should have these keys' do
            expect(Currencies.response.keys).to match_array [:success, :current_time, :currencies, :name, :url]
          end

          it 'the keys of the response attribute should have these values' do
            expect(Currencies.response[:success]).to eq 1
            expect(Currencies.response[:message]).to eq nil
            expect(Currencies.response[:current_time]).to eq 1430731956
            expect(Currencies.response[:name]).to eq 'Team Fortress 2'
            expect(Currencies.response[:url]).to eq 'http://backpack.tf'
          end

          it 'currencies attribute should be a Hash object' do
            expect(Currencies.currencies).to be_instance_of Hash
          end

          it 'currencies should have these keys' do
            expected_keys = [:metal, :keys, :earbuds, :hat]
            expect(Currencies.currencies.keys).to match_array expected_keys
          end
        end

        xcontext 'an unsuccessful response' do

          class Currencies_Unsuccessful < Currencies
          end

          it 'records the fixture' do
            opts = { :app_id => 440, :compress => 1 }
            Currencies_Unsuccessful.fetch(bp.get_data(:get_currencies, opts))
            expect(Currencies_Unsuccessful.response).not_to be_nil
          end

          before do
            VCR.insert_cassette 'currency_data_error', :record => :new_episodes
          end

          after do
            VCR.eject_cassette
          end

          it 'the response attribute should have these keys' do
            expect(Currencies_Unsuccessful.response.keys).to match_array [:success, :message, :current_time]
          end

          it 'the keys of response attribute should have these values along these lines' do
            expect(Currencies_Unsuccessful.response[:success]).to eq 0
            expect(Currencies_Unsuccessful.response[:message]).to eq 'API key does not exist.'
            expect(Currencies_Unsuccessful.response[:current_time]).to eq 1430700702
          end

        end

      end

    end

    describe 'instance of Currencies' do

      let (:metal) { Currencies.new(:metal, Currencies.currencies[:metal]) }

      before :all do
        opts = { :app_id => 440, :compress => 1 }
        Currencies.fetch( Client.new.get_data(:get_currencies, opts) )
        #print JSON.pretty_generate(Currencies.currencies[:metal]); puts
      end

      before do
        VCR.insert_cassette 'currency_data', :record => :new_episodes
      end

      after do
        VCR.eject_cassette
      end

      it 'should respond to these methods' do
        expect(metal).to respond_to :quality, :priceindex, :single, :plural, :round, :craftable, :tradable, :defindex, :blanket
      end

      it 'should have these values' do
        expect(metal.quality).to eq 6
        expect(metal.priceindex).to eq 0
        expect(metal.single).to eq 'ref'
        expect(metal.plural).to eq 'ref'
        expect(metal.round).to eq 2
        expect(metal.craftable).to eq :Craftable
        expect(metal.tradable).to eq :Tradable
        expect(metal.defindex).to eq 5002
        expect(metal.blanket).to eq 0
      end

    end

  end
end
