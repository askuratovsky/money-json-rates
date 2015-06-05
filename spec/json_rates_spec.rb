require 'spec_helper'

describe "JsonRates" do
  before :each do
    @bank = Money::Bank::JsonRates.new
  end

  it "should accept a ttl_in_seconds option" do
    Money::Bank::JsonRates.ttl_in_seconds = 86400
    expect(Money::Bank::JsonRates.ttl_in_seconds).to eq(86400)
  end

  describe ".refresh_rates_expiration!" do
    it "set the .rates_expiration using the TTL and the current time" do
      Money::Bank::JsonRates.ttl_in_seconds = 86400
      new_time = Time.now
      Timecop.freeze(new_time)
      Money::Bank::JsonRates.refresh_rates_expiration!
      expect(Money::Bank::JsonRates.rates_expiration).to eq(new_time + 86400)
    end
  end

  describe ".flush_rates" do
    it "should empty @rates" do
      @bank.add_rate("USD", "CAD", 1.24515)
      @bank.flush_rates
      expect(@bank.rates).to eq({})
    end
  end

  describe ".flush_rate" do
    it "should remove a specific rate from @rates" do
      @bank.add_rate('USD', 'EUR', 1.4)
      @bank.add_rate('USD', 'JPY', 0.3)
      @bank.flush_rate('USD', 'EUR')
      expect(@bank.rates).to include('USD_TO_JPY')
      expect(@bank.rates).to_not include('USD_TO_EUR')
    end
  end

  describe ".expire_rates" do
    before do
      Money::Bank::JsonRates.ttl_in_seconds = 1000
    end

    context "when the ttl has expired" do
      before do
        new_time = Time.now + 1001
        Timecop.freeze(new_time)
      end

      it "should flush all rates" do
        expect(@bank).to receive(:flush_rates)
        @bank.expire_rates
      end

      it "updates the next expiration time" do
        exp_time = Time.now + 1000

        @bank.expire_rates
        expect(Money::Bank::JsonRates.rates_expiration).to eq(exp_time)
      end
    end

    context "when the ttl has not expired" do
      it "not should flush all rates" do
        expect(@bank).to_not receive(:flush_rates)
        @bank.expire_rates
      end
    end
  end
end