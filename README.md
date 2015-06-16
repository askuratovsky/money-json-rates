# Money::Bank::JsonRates

[![Build Status](https://travis-ci.org/askuratovsky/money-json-rates.svg?branch=master)](https://travis-ci.org/askuratovsky/money-json-rates)

This gem extends Money::Bank::VariableExchange of gem [money](https://github.com/RubyMoney/money) and gives you access to the current exchange rates using jsonrates.com api

[GitHub Pages Website](http://askuratovsky.github.io/money-json-rates/)

## Warning

Since jsonrates is [becoming a part of apilayer’s currencylayer API](http://jsonrates.com/about/), jsonrates api is now deprecated. The previous jsonrates API and this gem shall be deprecated but will still be available for use until June 30th 11:59:59 PM London time.

Please register new account on [currencylayer.com](https://currencylayer.com/) and install gem [currencylayer](https://github.com/askuratovsky/currencylayer).

## Features

This gem uses [jsonrates.com api](http://jsonrates.com/), so

- it's free
- supports 168 currencies
- precision of rates up to 8 digits after point
- uses fast and reliable json api
- average response time < 20ms
- no limitations for requesting the API
- supports caching currency rates

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

First, you should to register account on [jsonrates.com](http://jsonrates.com/) and get your personal api_key.

```ruby
require 'money'
require 'money/bank/json_rates'

# (optional)
# set the seconds after than the current rates are automatically expired
# by default, they never expire
Money::Bank::JsonRates.ttl_in_seconds = 7200 # 2 hours ttl

# set careful mode - each rate stores with created_at time to cache and will be flushed
# only if their time is out. If you get exception while request new rate, bank will
# return cached value if present
# by default false
Money::Bank::JsonRates.rates_careful = true

# create new bank instance
bank = Money::Bank::JsonRates.new

# create new bank instance with block specifying rounding of exchange result
bank = Money::Bank::JsonRates.new {|n| n.round(4)} # round result to 4 digits after point

# specify your api_key from jsonrates.com
bank.api_key = 'xx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# set default bank to instance
Money.default_bank = bank
```

Also you can setup JsonRates as default_bank for [money-rails](https://github.com/RubyMoney/money-rails) gem in config/initializers/money.rb

```ruby
require 'money/bank/json_rates'
MoneyRails.configure do |config|

  bank = Money::Bank::JsonRates.new
  bank.api_key = 'xx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  config.default_bank = bank

end
```

An `NoApiKey` will be thrown if api_key was not specified.

An `JsonRatesRequestError` will be thrown if jsonrates.com api returns error on api request.


## Refs

Created using `VariableExchange` implementation and using `google_currency` basics.

- https://github.com/RubyMoney/money
- https://github.com/RubyMoney/google_currency

More implementations:

- https://github.com/RubyMoney/eu_central_bank
- https://github.com/matiaskorhonen/nordea
- https://github.com/slbug/nbrb_currency
- https://github.com/spk/money-open-exchange-rates
- https://github.com/atwam/money-historical-bank
- https://github.com/rmustafin/russian_central_bank

## Contributing

1. Fork it ( https://github.com/askuratovsky/money-json-rates/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
