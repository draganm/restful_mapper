# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restful_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "restful_mapper"
  spec.version       = RestfulMapper::VERSION
  spec.authors       = ["Dragan Milic"]
  spec.email         = ["dragan@netice9.com"]
  spec.summary       = %q{Mapper of RESTful services to ruby objects. Makes calling RESTful services and parsing responses a breeze.}
  spec.description   = %q{Mapper of RESTful services to ruby objects. Makes calling RESTful services and parsing responses a breeze.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "autotest"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "agent"
  spec.add_dependency "faraday"
  spec.add_dependency "multi_json"
  spec.add_dependency "structure_mapper"
  spec.add_dependency "mustache"
end
