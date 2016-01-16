require 'spec_helper'

describe BackpackTF::User do
  let(:json_response) {
    fixture = file_fixture('users.json')
    JSON.parse(fixture)['response']
  }

  it 'has these default attributes' do
    expect(described_class.interface).to eq :IGetUsers
  end

  describe '::response' do
    before(:context) do
      BackpackTF::User.class_eval { @response = nil }
    end
    before :each do
      responses_collection = { :'BackpackTF::User' => json_response }
      allow(described_class).
        to receive(:to_sym).
        and_return(:'BackpackTF::User')
      expect(described_class).
        to receive(:to_sym)
      allow(BackpackTF::Response).
        to receive(:responses).
        and_return(responses_collection)
      expect(BackpackTF::Response).
        to receive(:responses)
    end
    after :each do
      BackpackTF::User.class_eval { @response = nil }
    end

    it 'the keys of the response attribute should have these values' do
      response = described_class.response
      expect(response['success']).to eq 1
      expect(response['message']).to eq nil
      expect(response['current_time']).to eq 1431115863
    end
  end

  describe '::players' do
    before(:each) do
      response = json_response
      described_class.class_eval { @response = response }
    end
    after :each do
      BackpackTF::User.class_eval { @response = nil }
    end

    it 'has these 2 keys' do
      expected_keys = ['76561198012598620', '76561198045802942']
      actual = described_class.players.keys
      expect(actual).to match_array expected_keys
    end
    it 'each key points to an instance of BackpackTF::User' do
      actual = described_class.players.values
      expect(actual).to all be_a described_class
    end
  end

  describe '#initialize' do
    it 'an instance has these attributes' do
      attr = json_response['players']['76561198012598620']
      user = described_class.new(attr)
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
  end
end
