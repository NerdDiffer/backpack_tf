require 'spec_helper'

module BackpackTF
  describe User do
    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('users.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'responds to these methods' do
      expect(described_class).to respond_to :responses, :interface, :hash_keys_to_sym
    end

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetUsers
    end

    it 'an instance has these attributes' do
      some_json = JSON.parse(file_fixture 'users.json')['response']['players']['76561198012598620']
      user = described_class.new(some_json)
      expect(user).to have_attributes(
        :steamid => '76561198012598620',
        :success => 1,
        :backpack_value => { '440' => 521.4655, '570' => 0 },
        :name => 'Fiskie',
        :backpack_tf_reputation => 26,
        :backpack_tf_group => true,
        :backpack_tf_trust => { 'for' => 3, 'against' => 0 },
        :notifications => 0
      )
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

      it "Response class can access User response by calling the key User" do
        stub_http_response_with('users.json')
        opts = {:steamids => [76561198012598620,76561198045802942] }
        fetched_users = bp.fetch(:special_items, opts) 
        bp.update(described_class, fetched_users)
        expect(Response.responses[described_class.to_sym]).to eq json_obj
      end
    end

    describe '::response' do
      before :all do
        expect(described_class.response).to be_nil
      end

      before :each do
        stub_http_response_with('users.json')
        opts = {:steamids => [76561198012598620,76561198045802942]}
        fetched_users = bp.fetch(:users, opts) 
        bp.update(described_class, fetched_users)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        expect(described_class.response).to be_nil
        expect(described_class.players).to be_nil
      end

      it 'can access response information' do
        expect(described_class.response).to eq json_obj
      end
      it "returns same info as the Response class calling User key" do
        expect(described_class.response).to eq Response.responses[described_class.to_sym]
      end
      it 'the keys of the response attribute should have these values' do
        expect(described_class.response[:success]).to eq 1
        expect(described_class.response[:message]).to eq nil
        expect(described_class.response[:current_time]).to eq 1431115863
      end
    end

    describe '::players' do
      before :all do
        expect(described_class.response).to be_nil
        expect(described_class.players).to be_nil
      end

      before :each do
        stub_http_response_with('users.json')
        opts = {:steamids => [76561198012598620,76561198045802942]}
        fetched_users = bp.fetch(:users, opts) 
        bp.update(described_class, fetched_users)
      end

      after :all do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty
        described_class.class_eval { @players = nil }
      end

      it 'returns the fixture and sets to @@players variable' do
        expect(described_class.players).not_to be_nil
      end
      it 'is a Hash object' do
        expect(described_class.players).to be_instance_of Hash
      end
      it 'has these 2 keys' do
        expect(described_class.players.keys).to match_array ['76561198012598620', '76561198045802942']
      end
      it 'each key points to an instance of SpecialItem' do
        expect(described_class.players.values).to all be_a described_class
      end
    end

  end
end
