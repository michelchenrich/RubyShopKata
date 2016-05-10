require_relative 'money.rb'
require_relative 'unknown_rate_error.rb'

class Currency
  def self.instances
    @instances ||= Hash.new
  end

  def self.for(symbol)
    instances[symbol] ||= Currency.new(symbol)
  end

  def initialize(symbol)
    @symbol = symbol
    @rates = Hash.new
    rates[self] = 1.0
  end

  def money(number=0.0)
    Money.new(self, number)
  end

  def rates
    @rates
  end

  def set_rate(rate, other)
    self.rates[other] = rate
    other.rates[self] = 1 / rate
  end

  def get_rate(other)
    raise UnknownRateError unless rates.include?(other)
    rates[other]
  end

  def to_s
    @symbol.to_s
  end
end