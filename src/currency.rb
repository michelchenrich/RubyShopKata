require_relative 'money.rb'
require_relative 'unknown_rate_error.rb'

class Currency
  @currencies = Hash.new { |currencies, symbol| currencies[symbol] = self.new(symbol) }

  def self.for(symbol)
    @currencies[symbol]
  end

  def initialize(symbol)
    @symbol = symbol
    @rates = {self => 1.0}
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
    rates[other] or raise(UnknownRateError)
  end

  def to_s
    @symbol.to_s
  end
end