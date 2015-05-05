require 'spec_helper'

module BackpackTF

  class Dummy
    include BackpackTF::Finder
  end

  shared_examples 'Finder' do
    let(:dummy) { Dummy.new }

    it 'responds to these inherited class methods' do
      expect(Dummy).to respond_to(:get_item_price, :defindex_to_item_name, :find_item_by_name, :is_item_of_type?, :get_name_of_random_item)
    end

  end

  describe Prices do
    it_behaves_like 'Finder'
  end

  describe Item do
    it_behaves_like 'Finder'
  end

  describe ItemPrice do
    it_behaves_like 'Finder'
  end

end
