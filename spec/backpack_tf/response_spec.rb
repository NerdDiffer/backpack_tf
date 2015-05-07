require 'spec_helper'

module BackpackTF

  describe Response do
    let (:bp) { Client.new }

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

    describe '::interface' do
      it 'should be nil' do
        expect(Response.interface).to be_nil
      end
    end

    describe '::responses' do

      it 'returns a Hash object' do
        expect(Response.responses).to be_instance_of Hash
      end

      context 'expected input' do
        it 'has these keys' do
          stub_http_response_with('currencies.json')
          expect(bp.get_data(:get_currencies).keys).to eq ['response']
        end
      end

      context 'reset' do
        before :each do
          Response.responses(:currencies => json_obj)
          expect(Response.responses[:currencies]).to eq json_obj
        end
        it 'can be emptied by passing in `:reset => :confirm`' do
          Response.responses(:reset => :confirm)
          expect(Response.responses).to be_empty
        end
      end

      context 'reading' do

        before :each do
          Response.responses(:reset => :confirm)
          expect(Response.responses).to be_empty
        end

        it 'returns the value of the key' do
          res = { :currencies => json_obj }
          Response.responses(res)
          expect(Response.responses[:currencies]).to eq json_obj
        end
        it 'returns nil when key has no value' do
          Response.responses(:foo)
          expect(Response.responses[:foo]).to be_nil
        end
      end

      context 'updating' do

        before :each do
          Response.responses(:reset => :confirm)
          expect(Response.responses).to be_empty
        end

        it "updates a key's value when the key already exists" do
          entry1 = { :currencies => json_obj }
          Response.responses(entry1)
          expect(Response.responses[:currencies]).to eq json_obj
          entry2 = { :currencies => more_json }
          Response.responses(entry2)
          expect(Response.responses[:currencies]).to eq more_json
        end
        it 'creates a new key & value if key does not exist' do
          res = { :currencies => json_obj }
          expect(Response.responses(res)[:currencies]).to eq json_obj
        end
      end
    end

    describe '::hash_keys_to_sym' do
      it 'changes the type of each key from String to Symbol' do
        metal = {'quality'=>6, 'priceindex'=>0, 'single'=>'ref', 'plural'=>'ref', 'round'=>2, 'blanket'=>0, 'craftable'=>'Craftable', 'tradable'=>'Tradable', 'defindex'=>5002}
        hashed_metal = {:quality=>6, :priceindex=>0, :single=>'ref', :plural=>'ref', :round=>2, :blanket=>0, :craftable=>'Craftable', :tradable=>'Tradable', :defindex=>5002}
         expect(Response.hash_keys_to_sym(metal)).to eq hashed_metal
        end
    end

  end

end
