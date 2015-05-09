require 'spec_helper'

module BackpackTF
  describe Currency do
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
      expect(described_class).to respond_to :responses, :response, :currencies, :interface, :hash_keys_to_sym
    end

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetCurrencies
    end

    describe '::responses' do

      before :each do
        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(described_class.to_sym => fetched_currencies)
      end

      context 'access from Response class' do
        it 'Currency can be accessed by calling the key, Currency' do
          expect(Response.responses[:'BackpackTF::Currency']).to eq json_obj
        end
      end

      context 'access from Currency class' do
        it 'can access response information via the class method, ::response' do
          expect(described_class.response).to eq json_obj
        end
      end

      it 'is the same as calling Currency.response' do
        expect(Response.responses[:'BackpackTF::Currency']).to eq Currency.response
      end
    end

    describe '::response' do
      before :each do
        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(':BackpackTF::Currency' => fetched_currencies)
      end
      it 'the response attribute should have these keys' do
        expect(described_class.response.keys).to match_array [:success, :current_time, :currencies, :name, :url]
      end

      it 'the keys of the response attribute should have these values' do
        expect(described_class.response[:success]).to eq 1
        expect(described_class.response[:message]).to eq nil
        expect(described_class.response[:current_time]).to eq 1430784460
        expect(described_class.response[:name]).to eq 'Team Fortress 2'
        expect(described_class.response[:url]).to eq 'http://backpack.tf'
      end

    end

    describe '::currencies' do
      before :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty

        stub_http_response_with('currencies.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_currencies = bp.fetch(:currencies, opts)
        Response.responses(:'BackpackTF::Currency' => fetched_currencies)
      end

      it 'returns the fixture and sets to @@currencies variable' do
        expect(described_class.currencies).not_to be_nil
      end

      it '@@currencies attribute should be a Hash object' do
        expect(described_class.currencies).to be_instance_of Hash
      end

      it '@@currencies should have these keys' do
        expected_keys = [:metal, :keys, :earbuds, :hat]
        expect(described_class.currencies.keys).to match_array expected_keys
      end
    end

    describe 'instance of Currency' do

      let (:metal) { described_class.new(:metal, Currency.currencies[:metal]) }

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
