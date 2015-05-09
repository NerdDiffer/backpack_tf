require 'spec_helper'

module BackpackTF
  describe Price do

    let(:bp) { Client.new }

    let(:json_obj) {
      fixture = file_fixture('prices.json')
      fixture = JSON.parse(fixture)['response']
      Response.hash_keys_to_sym(fixture)
    }

    it 'responds to these methods' do
      expect(described_class).to respond_to :responses, :response, :items, :interface, :hash_keys_to_sym
    end

    it 'has these default attributes' do
      expect(described_class.interface).to eq :IGetPrices
    end

    describe '::responses' do

      before :each do
        stub_http_response_with('prices.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_prices = bp.fetch(:prices, opts)
        Response.responses(described_class.to_sym => fetched_prices)
      end

      context 'access from Response class' do
        it "Price can be accessed by calling the key, Price" do
          expect(Response.responses[described_class.to_sym]).to eq json_obj
        end
      end

      context "access from Price class" do
        it 'can access response information via the class method, ::response' do
          expect(described_class.response).to eq json_obj
        end
      end

      it "is the same as calling Price.response" do
        expect(Response.responses[described_class.to_sym]).to eq described_class.response
      end
    end

    describe '::response' do

      before :each do
        stub_http_response_with('prices.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_prices = bp.fetch(:prices, opts)
        Response.responses(described_class.to_sym => fetched_prices)
      end

      it 'the response attribute should have these keys' do
        expect(described_class.response.keys).to match_array [:success, :current_time, :raw_usd_value, :usd_currency, :usd_currency_index, :items]
      end

      it 'the keys of the response attribute should have these values' do
        expect(described_class.response[:success]).to eq 1
        expect(described_class.response[:message]).to eq nil
        expect(described_class.response[:current_time]).to eq 1430785805
        expect(described_class.response[:raw_usd_value]).to eq 0.115
        expect(described_class.response[:usd_currency]).to eq 'metal'
        expect(described_class.response[:usd_currency_index]).to eq 5002
      end

    end

    describe '::items' do

      before :each do
        Response.responses(:reset => :confirm)
        expect(Response.responses).to be_empty

        stub_http_response_with('prices.json')
        opts = { :app_id => 440, :compress => 1 }
        fetched_prices = bp.fetch(:prices, opts)
        Response.responses(described_class => fetched_prices)
      end

      it 'returns the fixture and sets to @@items variable' do
        expect(described_class.items).not_to be_nil
      end

      context '@@items attribute' do
        it 'should be a Hash object' do
          expect(described_class.items).to be_instance_of Hash
        end
        xit 'should have this many keys' do
          expect(described_class.items.keys.length).to be 1661
        end
        it 'each key should be a String' do
          expect(described_class.items.keys).to all be_a String
        end
        it 'each value should be an Item' do
          expect(described_class.items.values).to all be_an Item
        end
      end

      context 'using keys to generate Item objects' do
        let(:random_key) { described_class.items.keys.sample }
        let(:item) { described_class.items[random_key] }

        it 'generates an Item object' do
          expect(item).to be_instance_of Item
        end
        it 'the Item object responds to these methods' do
          expect(item).to respond_to :item_name, :defindex, :prices
        end
        it 'uses the key to assign a value to the @item_name property of the Item' do
          expect(random_key).to eq item.item_name
        end
        it 'passes itself to be stored in the @prices attribute of the Item object' do
          expect(described_class.items[random_key].prices).to eq item.prices
        end
      end

    end

    describe 'instances of Price' do
      it 'raises an error when trying to instantiate this class' do
        expect{described_class.new}.to raise_error RuntimeError
      end
    end

  end
end
