# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "money-json-rates"
  spec.version       = '0.1.0'
  spec.authors       = ["Andrey Skuratovsky"]
  spec.email         = ["skuratowsky@gmail.com"]
  spec.summary       = "Access the jsonrates.com for gem money"
  spec.description   = "Ruby Money::Bank interface for jsonrates.com exchange data"
  spec.homepage      = "http://github.com/askuratovsky/#{spec.name}"
  spec.license       = "MIT"

  spec.files         =  Dir.glob("{lib,spec}/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency "money", "~> 6.5.0"

  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
