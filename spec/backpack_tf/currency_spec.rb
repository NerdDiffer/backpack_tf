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

    it 'class responds to these methods' do
      expect(described_class).to respond_to :responses, :response, :currencies, :interface, :hash_keys_to_sym
    end

    it 'class has these default attributes' do
      expect(described_class.interface).to eq :IGetCurrencies
    end

    describe '::responses' do
      before :all do
        expect(Response.responses).to be_empty
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
      end

      it "Responses class can access Currency response by calling Currency key" do
        stub_http_response_with('currencies.json')
        fetched_currencies = bp.fetch(:currencies)
        bp.update(described_class, fetched_currencies)
        expect(Response.responses[described_class.to_sym]).to eq json_obj
      end
    end

    describe '::response' do
      before :all do
        expect(described_class.response).to be_nil
      end

      before :each do
        stub_http_response_with('currencies.json')
        fetched_currencies = bp.fetch(:currencies)
        bp.update(described_class, fetched_currencies)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
        expect(described_class.currencies).to be_nil
      end

      it 'can access response information' do
        expect(described_class.response).to eq json_obj
      end
      it "returns same info as the Response class calling Currency key" do
        expect(described_class.response).to eq Response.responses[described_class.to_sym]
      end
      it 'the keys of the response attribute should have these values' do
        response = described_class.response
        expect(response[:success]).to eq 1
        expect(response[:message]).to eq nil
        expect(response[:current_time]).to eq 1430784460
        expect(response[:name]).to eq 'Team Fortress 2'
        expect(response[:url]).to eq 'http://backpack.tf'
      end
    end

    describe '::currencies' do
      before :all do
        expect(described_class.response).to be_nil
        expect(described_class.currencies).to be_nil
      end

      before :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty

        stub_http_response_with('currencies.json')
        fetched_currencies = bp.fetch(:currencies)
        bp.update(described_class, fetched_currencies)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @currencies = nil }
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

    describe '#initialize' do

      before :all do
        expect(described_class.response).to be_nil
        expect(described_class.currencies).to be_nil
      end

      before :each do
        bp.update(described_class, json_obj)
        expect(described_class.currencies).not_to be_nil
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @currencies = nil }
      end

      subject {
        described_class.new(:metal, described_class.currencies[:metal])
      }

      it 'instance should respond to these methods' do
        expect(subject).to respond_to(:quality, :priceindex, :single, :plural, :round, :craftable, :tradable, :defindex, :blanket)
      end

      it 'instance should have these values' do
        expect(subject.quality).to eq 6
        expect(subject.priceindex).to eq 0
        expect(subject.single).to eq 'ref'
        expect(subject.plural).to eq 'ref'
        expect(subject.round).to eq 2
        expect(subject.craftable).to eq :Craftable
        expect(subject.tradable).to eq :Tradable
        expect(subject.defindex).to eq 5002
        expect(subject.blanket).to eq 0
      end
    end

  end
end
