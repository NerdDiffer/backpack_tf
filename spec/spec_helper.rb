require 'backpack_tf'
require 'webmock/rspec'
require 'vcr'

def generate_fake_api_key
  hex_nums = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f)
  key = ''
  24.times{ |k| key << hex_nums.sample }
  key
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/'
  c.hook_into :webmock
end
