require 'spec_helper'

describe BackpackTF::User::Response do
  let(:json_response) {
    fixture = file_fixture('users.json')
    JSON.parse(fixture)['response']
  }

  describe '::players' do
    before(:each) do
      described_class.response = json_response
    end
    after :each do
      described_class.response = nil
    end

    it 'has these 2 keys' do
      expected_keys = ['76561198012598620', '76561198045802942']
      actual = described_class.players.keys
      expect(actual).to match_array expected_keys
    end
    it 'each key points to an instance of BackpackTF::User' do
      actual = described_class.players.values
      expect(actual).to all be_a BackpackTF::User
    end
  end
end
