require 'spec_helper'

describe BackpackTF::Currency::Interface do
  it 'has these attributes' do
    expect(described_class.name).to eq :IGetCurrencies
    expect(described_class.version).to eq 1
  end
end
