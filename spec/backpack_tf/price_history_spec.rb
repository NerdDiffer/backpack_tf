require 'spec_helper'

describe BackpackTF::PriceHistory do
  let(:response_attr) do
    {
      'value'      => 2.5,
      'value_high' => 2.5,
      'currency'   => 'keys',
      'timestamp'  => 1346988149
    }
  end

  describe '#initialize' do
    it 'has these these attributes' do
      price_history = described_class.new(response_attr)
      expect(price_history).to have_attributes(
        value: 2.5,
        value_high: 2.5,
        currency: 'keys',
        timestamp: 1346988149
      )
    end
  end
end
