# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-blockwart/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-blockwart"
  spec.version       = Vagrant::Blockwart::VERSION
  spec.authors       = "Benjamin Kendinibilir"
  spec.email         = "bkendinibilir@seibert-media.net"
  spec.summary       = "Vagrant Blockwart provisioner."
  spec.description   = "Enables Vagrant to provision machines with Blockwart."
  spec.homepage      = "http://blockwart.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "erb"
  spec.add_runtime_dependency "ostruct" 
  spec.add_runtime_dependency "ssh-config", "~> 0.1.3"
end
