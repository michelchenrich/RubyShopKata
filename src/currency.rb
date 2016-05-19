require_relative 'money.rb'
require_relative 'unknown_rate_error.rb'

class Currency
  @currencies = Hash.new

  def self.for(code)
    code_symbol = code.to_sym
    @currencies[code_symbol] ||= self.new(code_symbol)
  end

  def initialize(code)
    @code = code
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
    @code.to_s
  end
end