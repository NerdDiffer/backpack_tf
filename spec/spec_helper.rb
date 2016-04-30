require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
SimpleCov.start

require 'backpack_tf'
require 'webmock/rspec'

RSpec.configure do |config|
  config.default_formatter = 'doc' if config.files_to_run.one?
end

def generate_fake_api_key
  hex_nums = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f)
  key = ''
  24.times { key << hex_nums.sample }
  key
end

WebMock.disable_net_connect!(allow: 'codeclimate.com')

# taken from httparty's spec dir
# https://github.com/jnunemaker/httparty/blob/master/spec/spec_helper.rb
def file_fixture(filename)
  filename = File.join(File.dirname(__FILE__), 'fixtures', filename.to_s)
  File.open(filename).read
end

# taken from httparty's spec dir
# https://github.com/jnunemaker/httparty/blob/master/spec/spec_helper.rb
def stub_http_response_with(filename)
  format = filename.split('.').last.intern
  data = file_fixture(filename)
  response = Net::HTTPOK.new('1.1', 200, 'Content for you')
  allow(response).to receive(:body).and_return(data)

  request = HTTParty::Request.new(Net::HTTP::Get,
                                  'http://localhost',
                                  format: format)
  allow(request).
    to receive_message_chain(:http, :request).
    and_return(response)

  expect(HTTParty::Request).to receive(:new).and_return(request)
end
