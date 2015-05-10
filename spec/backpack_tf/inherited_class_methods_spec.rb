require 'spec_helper'

module BackpackTF

  shared_examples 'a class inheriting methods from Response' do |file|
    let(:bp) { Client.new }
    let(:json_obj) {
      fixture = file_fixture(file)
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    before :all do
      mock_alias
    end

    it 'should respond to these inherited methods' do
      expect(described_class).to respond_to :responses, :interface, :to_sym, :hash_keys_to_sym
    end

    it 'should respond to this aliased method (for testing only)' do
      expect(described_class).to respond_to :data_storage
    end

    describe '::to_sym' do
      it 'returns a Symbol of the name of the name of the class' do
        expect(described_class.to_sym).to eq described_class.to_s.to_sym
      end
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

      it "Response class can access response for #{described_class} by calling the key #{described_class}" do
        stub_http_response_with(file)
        fetched_data = bp.fetch(make_fetch_sym)
        bp.update(described_class, fetched_data)
        expect(Response.responses[described_class.to_sym]).to eq json_obj
      end
    end

    describe '::response' do
      before :all do
        expect(described_class.response).to be_nil
      end

      before :each do
        stub_http_response_with(file)
        fetched_data = bp.fetch(make_fetch_sym)
        bp.update(described_class, fetched_data)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
        expect(described_class.data_storage).to be_nil
      end

      it 'can access response information' do
        expect(described_class.response).to eq json_obj
      end

      it "returns same info as the Response class calling Price key" do
        result = Response.responses[described_class.to_sym]
        expect(described_class.response).to eq result
      end
    end

  end

  describe Price do
    it_behaves_like('a class inheriting methods from Response', 'prices.json')
  end

  describe Currency do
    it_behaves_like('a class inheriting methods from Response', 'currencies.json')
  end

  describe SpecialItem do
    it_behaves_like('a class inheriting methods from Response', 'special_items.json')
  end

  describe User do
    it_behaves_like('a class inheriting methods from Response', 'users.json')
  end

  describe UserListing do
    it_behaves_like('a class inheriting methods from Response', 'user_listing.json')
  end

end
