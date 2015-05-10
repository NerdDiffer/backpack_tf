require 'backpack_tf'
require 'webmock/rspec'

def generate_fake_api_key
  hex_nums = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f)
  key = ''
  24.times{ |k| key << hex_nums.sample }
  key
end

# taken from httparty's spec dir
# https://github.com/jnunemaker/httparty/blob/master/spec/spec_helper.rb
def file_fixture(filename)
  filename = File.join( File.dirname(__FILE__), "fixtures", "#{filename}")
  File.open(filename).read
end

# taken from httparty's spec dir
# https://github.com/jnunemaker/httparty/blob/master/spec/spec_helper.rb
def stub_http_response_with(filename)
  format = filename.split('.').last.intern
  data = file_fixture(filename)
  response = Net::HTTPOK.new('1.1', 200, 'Content for you')
  allow(response).to receive(:body).and_return(data)

  http_request = HTTParty::Request.new(Net::HTTP::Get, 'http://localhost', format: format)
  allow(http_request).to receive_message_chain(:http, :request).and_return(response)

  expect(HTTParty::Request).to receive(:new).and_return(http_request)
end

def make_fetch_sym
  opt = described_class.to_s
  ind_after_scope_operator = opt.index('::') + 2
  opt = opt[ind_after_scope_operator..-1]
  opt.downcase.to_sym
end

def mock_alias

  case described_class.to_s

  when BackpackTF::Price.to_s
    described_class.class_eval do
      class << self; attr_class_alias(:data_storage, :items); end
    end
  when BackpackTF::Currency.to_s
    described_class.class_eval do
      class << self; attr_class_alias :data_storage, :currencies; end
    end
  when BackpackTF::SpecialItem.to_s
    described_class.class_eval do
      class << self; attr_class_alias :data_storage, :items; end
    end
  when BackpackTF::User.to_s
    described_class.class_eval do
      class << self; attr_class_alias :data_storage, :players; end
    end
  when BackpackTF::UserListing.to_s
    described_class.class_eval do
      class << self; attr_class_alias :data_storage, :listings; end
    end
  else
    raise RuntimeError, "#{described_class} != described_class"
  end

end

# credit: http://stackoverflow.com/a/913453/2908123
class Module
  def attr_class_alias(new_attr, original_attr)
    alias_method(new_attr, original_attr) if method_defined? original_attr
    new_writer = "#{new_attr}="
    original_writer = "#{original_attr}="
    alias_method(new_writer, original_writer) if method_defined? original_writer
  end
end
