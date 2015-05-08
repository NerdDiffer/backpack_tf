require 'spec_helper'

module BackpackTF
  describe 'Currencies' do
    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('currencies.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    let(:more_json) {
      fixture = file_fixture('currencies_updated.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'responds to these methods' do
      expect(Currencies).to respond_to :responses, :response, :currencies, :interface, :hash_keys_to_sym
    end

    it 'has these default attributes' do
      expect(Currencies.interface).to eq :IGetCurrencies
    end

    describe '::responses' do

      before :each do
        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(Currencies.to_sym => fetched_currencies)
      end

      context 'access from Response class' do
        it 'Currencies can be accessed by calling the key, Currencies' do
          expect(Response.responses[:'BackpackTF::Currencies']).to eq json_obj
        end
      end

      context 'access from Currencies class' do
        it 'can access response information via the class method, ::response' do
          expect(Currencies.response).to eq json_obj
        end
      end

      it 'is the same as calling Currencies.response' do
        expect(Response.responses[:'BackpackTF::Currencies']).to eq Currencies.response
      end
    end

    describe '::response' do
      before :each do
        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(':BackpackTF::Currencies' => fetched_currencies)
      end
      it 'the response attribute should have these keys' do
        expect(Currencies.response.keys).to match_array [:success, :current_time, :currencies, :name, :url]
      end

      it 'the keys of the response attribute should have these values' do
        expect(Currencies.response[:success]).to eq 1
        expect(Currencies.response[:message]).to eq nil
        expect(Currencies.response[:current_time]).to eq 1430784460
        expect(Currencies.response[:name]).to eq 'Team Fortress 2'
        expect(Currencies.response[:url]).to eq 'http://backpack.tf'
      end

    end

    describe '::currencies' do
      before :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty

        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(:'BackpackTF::Currencies' => fetched_currencies)
      end

      it 'returns the fixture and sets to @@currencies variable' do
        expect(Currencies.currencies).not_to be_nil
      end

      it '@@currencies attribute should be a Hash object' do
        expect(Currencies.currencies).to be_instance_of Hash
      end

      it '@@currencies should have these keys' do
        expected_keys = [:metal, :keys, :earbuds, :hat]
        expect(Currencies.currencies.keys).to match_array expected_keys
      end
    end

    describe 'instance of Currencies' do

      let (:metal) { Currencies.new(:metal, Currencies.currencies[:metal]) }

      it 'should respond to these methods' do
        expect(metal).to respond_to(:quality, :priceindex, :single, :plural, :round, :craftable, :tradable, :defindex, :blanket)
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
