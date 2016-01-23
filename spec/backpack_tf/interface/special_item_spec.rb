require 'spec_helper'

describe BackpackTF::SpecialItem::Interface do
  it 'has these default attributes' do
    expect(described_class.name).to eq :IGetSpecialItems
    expect(described_class.version).to eq 1
  end
end
