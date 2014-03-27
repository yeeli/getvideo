# -*- encoding: utf-8 -*-
require File.expand_path('../lib/getvideo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "getvideo"
  gem.license = 'MIT'
  gem.authors       = ["ye.li"]
  gem.email         = ["yeeli@outlook.com"]
  gem.description   = "get video"
  gem.summary       = "get video" 
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Getvideo::VERSION
  gem.add_dependency 'faraday'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'multi_xml'
  gem.add_dependency 'nokogiri'
end
