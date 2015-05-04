Gem::Specification.new do |s|
  s.name          = 'backpack_tf'
  s.version       = '0.0.11'
  s.date          = '2015-05-01'
  s.summary       = 'a wrapper for the backpack.tf API'
  s.author        = 'Rafael Espinoza'
  s.email         = 'rafael@rafaelespinoza.com'
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/NerdDiffer/backpack_tf'
  s.license       = 'MIT'
  s.description   = s.summary

  s.add_runtime_dependency 'httparty',    '~>0.13',   '>=0.13.3'

  s.add_development_dependency 'rspec',   '~>3.2',    '>=3.2.0'
  s.add_development_dependency 'vcr',     '~>2.9',    '>=2.9.3'
  s.add_development_dependency 'webmock', '~>1.21',   '>=1.21.0'
end
