require 'spec_helper'

describe BackpackTF::MarketPrice::Interface do
  it 'has these attributes' do
    expect(described_class.name).to eq :IGetMarketPrices
    expect(described_class.version).to eq 1
  end
end
