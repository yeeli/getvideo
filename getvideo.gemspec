# -*- encoding: utf-8 -*-
require File.expand_path('../lib/getvideo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ye.li"]
  gem.email         = ["ye@ono.li"]
  gem.description   = "get video"
  gem.summary       = "get video" 
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "getvideo"
  gem.require_paths = ["lib"]
  gem.version       = Getvideo::VERSION
end
