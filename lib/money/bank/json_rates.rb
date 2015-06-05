require 'money'
require 'open-uri'
require 'money/bank/json_rates/version'

class Money
  module Bank

    class JsonRatesRequestError < StandardError ; end

    class NoApiKey < StandardError
      def message
        "Blank api_key! You should get your api_key on jsonrates.com and specify it like JsonRates.api_key = YOUR_API_KEY"
      end
    end

    class JsonRates < Money::Bank::VariableExchange

      SERVICE_HOST = "jsonrates.com"
      SERVICE_PATH = "/get"

      # @return [Hash] Stores the currently known rates.
      attr_reader :rates

      attr_accessor :cache, :api_key

      class << self
        # @return [Integer] Returns the Time To Live (TTL) in seconds.
        attr_reader :ttl_in_seconds

        # @return [Time] Returns the time when the rates expire.
        attr_reader :rates_expiration

        ##
        # Set the Time To Live (TTL) in seconds.
        #
        # @param [Integer] the seconds between an expiration and another.
        def ttl_in_seconds=(value)
          @ttl_in_seconds = value
          refresh_rates_expiration! if ttl_in_seconds
        end

        ##
        # Set the rates expiration TTL seconds from the current time.
        #
        # @return [Time] The next expiration.
        def refresh_rates_expiration!
          @rates_expiration = Time.now + ttl_in_seconds
        end
      end

      ##
      # Clears all rates stored in @rates
      #
      # @return [Hash] The empty @rates Hash.
      #
      # @example
      #   @bank = JsonRates.new  #=> <Money::Bank::JsonRates...>
      #   @bank.get_rate(:USD, :EUR)  #=> 0.776337241
      #   @bank.flush_rates           #=> {}
      def flush_rates
        @mutex.synchronize{
          @rates = {}
        }
      end

      ##
      # Clears the specified rate stored in @rates.
      #
      # @param [String, Symbol, Currency] from Currency to convert from (used
      #   for key into @rates).
      # @param [String, Symbol, Currency] to Currency to convert to (used for
      #   key into @rates).
      #
      # @return [Float] The flushed rate.
      #
      # @example
      #   @bank = JsonRates.new    #=> <Money::Bank::JsonRates...>
      #   @bank.get_rate(:USD, :EUR)    #=> 0.776337241
      #   @bank.flush_rate(:USD, :EUR)  #=> 0.776337241
      def flush_rate(from, to)
        key = rate_key_for(from, to)
        @mutex.synchronize{
          @rates.delete(key)
        }
      end

      ##
      # Returns the requested rate.
      #
      # It also flushes all the rates when and if they are expired.
      #
      # @param [String, Symbol, Currency] from Currency to convert from
      # @param [String, Symbol, Currency] to Currency to convert to
      #
      # @return [Float] The requested rate.
      #
      # @example
      #   @bank = JsonRates.new  #=> <Money::Bank::JsonRates...>
      #   @bank.get_rate(:USD, :EUR)  #=> 0.776337241
      def get_rate(from, to)
        expire_rates

        @mutex.synchronize{
          @rates[rate_key_for(from, to)] ||= fetch_rate(from, to)
        }
      end

      ##
      # Flushes all the rates if they are expired.
      #
      # @return [Boolean]
      def expire_rates
        if self.class.ttl_in_seconds && self.class.rates_expiration <= Time.now
          flush_rates
          self.class.refresh_rates_expiration!
          true
        else
          false
        end
      end

      private

      ##
      # Queries for the requested rate and returns it.
      #
      # @param [String, Symbol, Currency] from Currency to convert from
      # @param [String, Symbol, Currency] to Currency to convert to
      #
      # @return [BigDecimal] The requested rate.
      def fetch_rate(from, to)
        from, to = Currency.wrap(from), Currency.wrap(to)
        data = build_uri(from, to).read
        extract_rate(data)
      end

      ##
      # Build a URI for the given arguments.
      #
      # @param [Currency] from The currency to convert from.
      # @param [Currency] to The currency to convert to.
      #
      # @return [URI::HTTP]
      def build_uri(from, to)
        raise NoApiKey if api_key.blank?
        uri = URI::HTTP.build(
          :host  => SERVICE_HOST,
          :path  => SERVICE_PATH,
          :query => "from=#{from.iso_code}&to=#{to.iso_code}&apiKey=#{api_key}"
        )
      end

      ##
      # Takes the response from jsonrates.com and extract the rate.
      # @return [BigDecimal]
      def extract_rate(data)
        request_hash = JSON.parse(data)
        raise JsonRatesRequestError, request_hash['error'] if request_hash['error'].present?
        BigDecimal.new(request_hash['rate'])
      end
    end
  end
end