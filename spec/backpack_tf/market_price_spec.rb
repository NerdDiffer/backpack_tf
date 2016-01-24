require 'spec_helper'

describe BackpackTF::MarketPrice do
  let(:response_attr) do
    {
      'last_updated' => 1453654816,
      'quantity' => 52,
      'value' => 89
    }
  end

  describe '#initialize' do
    it 'has these attributes' do
      actual = described_class.new('A Color Similar to Slate', response_attr)
      expect(actual).to have_attributes(
        last_updated: 1453654816,
        quantity: 52,
        value: 89
      )
    end
  end
end
