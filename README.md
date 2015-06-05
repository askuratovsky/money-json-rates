# JsonRates

This gem extends Money::Bank::VariableExchange with Money::Bank::JsonRates and gives you access to the current [jsonrates.com](http://jsonrates.com/) exchange rates using json api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'money-json-rates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install money-json-rates

## Usage

    require 'money'
    require 'money/bank/json_rates'

    # create new bank
    bank = Money::Bank::JsonRates.new

    # create new bank with block specifying rounding of exchange result
    bank = Money::Bank::JsonRates.new {|n| n.round(4)} # round result to 4 digits after point

    # specify your api_key from jsonrates.com
    bank.api_key = xx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    # set the seconds after than the current rates are automatically expired
    # by default, they never expire
    bank.ttl_in_seconds = 86400

    # set default bank to instance
    Money.default_bank = bank

Also you can setup JsonRates as default_bank in money initializer in config/initializers/money.rb

    require 'money/bank/json_rates'
    MoneyRails.configure do |config|

      bank = Money::Bank::JsonRates.new
      bank.api_key = xx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      Money.default_bank = bank

    end

An `NoApiKey` will be thrown if api_key was not specified.

An `JsonRatesRequestError` will be thrown if jsonrates.com api error on api request.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/money-json-rates/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
