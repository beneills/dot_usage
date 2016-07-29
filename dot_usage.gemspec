# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dot_usage/version'

Gem::Specification.new do |spec|
  spec.name          = "dot_usage"
  spec.version       = DotUsage::VERSION
  spec.authors       = ["Ben Eills"]
  spec.email         = ["ben@beneills.com"]

  spec.summary       = %q{File format and utility to control building, running and testing source code.}
  spec.homepage      = "https://github.com/beneills/dot_usage"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
