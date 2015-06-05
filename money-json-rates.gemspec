# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "money-json-rates"
  spec.version       = '0.0.2'
  spec.authors       = ["Andrey Skuratovsky"]
  spec.email         = ["skuratowsky@gmail.com"]
  spec.summary       = "Access the jsonrates.com for gem money"
  spec.description   = "MoneyJsonRates extends Money::Bank::Base and gives access to the current exchange rates using http://jsonrates.com/ api."
  spec.homepage      = "http://github.com/askuratovsky/#{spec.name}"
  spec.license       = "MIT"

  spec.files         =  Dir.glob("{lib,spec}/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency "money", "~> 6.5.0"

  spec.add_development_dependency "rspec", ">= 3.0.0"
end
