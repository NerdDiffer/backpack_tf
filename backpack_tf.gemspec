require_relative './lib/backpack_tf/version.rb'

Gem::Specification.new do |s|
  s.name          = 'backpack_tf'
  s.date          = '2015-05-12'
  s.summary       = 'a wrapper for the backpack.tf API'
  s.author        = 'Rafael Espinoza'
  s.email         = 'rafael@rafaelespinoza.com'
  s.homepage      = 'https://github.com/NerdDiffer/backpack_tf'
  s.license       = 'MIT'
  s.description   = 'API client, accessor methods for backpack.tf'

  s.require_paths = ['lib']
  s.files         = `git ls-files`.split("\n")
  s.version       = BackpackTF::VERSION
  s.required_ruby_version = '>=1.9.3'

  s.add_runtime_dependency 'httparty',    '~>0.13',   '>=0.13.3'

  s.add_development_dependency 'rspec',   '~>3.2',    '>=3.2.0'
  s.add_development_dependency 'webmock', '~>1.21',   '>=1.21.0'
end
