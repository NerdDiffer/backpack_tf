require 'spec_helper'

describe BackpackTF::User do
  let(:json_response) do
    fixture = file_fixture('users.json')
    JSON.parse(fixture)['response']
  end

  describe '#initialize' do
    it 'an instance has these attributes' do
      attr = json_response['players']['76561198012598620']
      user = described_class.new(attr)
      expect(user).to have_attributes(
        steamid: '76561198012598620',
        success: 1,
        backpack_value: { '440' => 521.4655, '570' => 0 },
        name: 'Fiskie',
        backpack_tf_reputation: 26,
        backpack_tf_group: true,
        backpack_tf_trust: { 'for' => 3, 'against' => 0 },
        notifications: 0
      )
    end
  end
end
