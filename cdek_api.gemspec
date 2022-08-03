lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cdek_api/version'

Gem::Specification.new do |s|
  s.name        = 'cdek_api'
  s.version     = CdekApi::VERSION
  s.date        = '2022-08-03'
  s.summary     = "CDEK API"
  s.description = ""
  s.authors     = ["Pavel Osetrov"]
  s.email       = 'pavel.osetrov@me.com'
  s.files = Dir['lib/**/*', 'LICENSE', 'README.markdown']

  s.homepage    = 'https://github.com/osetrov/cdek_api'
  s.license       = 'MIT'

  s.add_dependency('faraday', '>= 0.16.0')
  s.add_dependency('multi_json', '>= 1.11.0')

  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.5'
end
