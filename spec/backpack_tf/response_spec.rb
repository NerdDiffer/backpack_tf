require 'spec_helper'

describe BackpackTF::Response do
  let (:bp) { BackpackTF::Client.new('deadbeef01234567deadbeef') }
  let (:faked_class_sym) { :'BackpackTF::FakedClass' }
  let(:json_obj) {
    fixture = file_fixture('currencies.json')
    fixture = JSON.parse(fixture)['response']
    described_class.hash_keys_to_sym(fixture)
  }
  let(:more_json) {
    fixture = file_fixture('currencies_updated.json')
    fixture = JSON.parse(fixture)['response']
    described_class.hash_keys_to_sym(fixture)
  }

  describe '::to_sym' do
    it 'should return the name of the class, as a Symbol object' do
      expect(BackpackTF::Response.to_sym).to eq :'BackpackTF::Response'
    end
  end

  describe '::responses' do
    after :context do
      BackpackTF::Response.responses(:reset => :confirm)
      expect(BackpackTF::Response.responses).to be_empty
      expect(described_class.response).to be_nil
    end

    context 'expected input' do
      it 'has these keys' do
        stub_http_response_with('currencies.json')
        expected_keys = ['success', 'currencies', 'name', 'url', 'current_time']
        expect(bp.fetch(:currencies).keys).to eq expected_keys
      end
    end

    context 'resetting' do
      before :each do
        BackpackTF::Response.responses(faked_class_sym => json_obj)
        expect(BackpackTF::Response.responses[faked_class_sym]).to eq json_obj
      end

      it 'can be emptied by passing in `:reset => :confirm`' do
        BackpackTF::Response.responses(:reset => :confirm)
        expect(BackpackTF::Response.responses).to be_empty
      end
    end

    context 'reading' do
      before :each do
        BackpackTF::Response.responses(:reset => :confirm)
        expect(BackpackTF::Response.responses).to be_empty
      end

      it 'returns the value of the key' do
        res = { faked_class_sym => json_obj }
        BackpackTF::Response.responses(res)
        expect(BackpackTF::Response.responses[faked_class_sym]).to eq json_obj
      end
      it 'returns nil when key has no value' do
        BackpackTF::Response.responses(:foo)
        expect(BackpackTF::Response.responses[:foo]).to be_nil
      end
    end

    context 'updating' do
      before :each do
        BackpackTF::Response.responses(:reset => :confirm)
        expect(BackpackTF::Response.responses).to be_empty
      end

      it "updates a key's value when the key already exists" do
        entry1 = { faked_class_sym => json_obj }
        BackpackTF::Response.responses(entry1)
        expect(BackpackTF::Response.responses[faked_class_sym]).to eq json_obj
        entry2 = { faked_class_sym => more_json }
        BackpackTF::Response.responses(entry2)
        expect(BackpackTF::Response.responses[faked_class_sym]).to eq more_json
      end
      it 'creates a new key & value if key does not exist' do
        res = { faked_class_sym => json_obj }
        actual = BackpackTF::Response.responses(res)[faked_class_sym]
        expect(actual).to eq json_obj
      end
      it 'is not nil when you reference entire hash object' do
        BackpackTF::Response.responses( { faked_class_sym => json_obj } )
        expect(BackpackTF::Response.responses).not_to be_nil
      end
    end
  end

  describe '::response' do
    it "returns nil when called by #{described_class}" do
      expect(described_class.response).to be_nil
    end
  end

  describe '::hash_keys_to_sym' do
    it 'changes the type of each key from String to Symbol' do
      metal = {
        'quality'=>6,
        'single'=>'ref'
      }
      hashed_metal = {
        :quality=>6,
        :single=>'ref'
      }
      expect(BackpackTF::Response.hash_keys_to_sym(metal)).to eq hashed_metal
    end
  end
end
