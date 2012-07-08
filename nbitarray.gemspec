# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nbitarray/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yusuke Mito"]
  gem.email         = ["y310.1984@gmail.com"]
  gem.description   = %q{Pure Ruby n-bit array implementation.}
  gem.summary       = %q{Pure Ruby n-bit array implementation.}
  gem.homepage      = "https://github.com/y310/nbitarray"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nbitarray"
  gem.require_paths = ["lib"]
  gem.version       = NBitArray::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'pry-debugger'
end
