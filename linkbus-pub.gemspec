# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linkbus/pub/version'

Gem::Specification.new do |spec|
  spec.name          = "linkbus-pub"
  spec.version       = Linkbus::Pub::VERSION
  spec.authors       = ["Thiago Dantas"]
  spec.email         = ["thiago.teixeira.dantas@gmail.com"]
  spec.description   = "Linkbus publisher"
  spec.summary       = "Linkbus publisher"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "bunny"

end
