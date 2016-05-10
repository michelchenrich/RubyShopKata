class Money
  def initialize(currency, amount)
    @currency = currency
    @amount = amount
  end

  def currency
    @currency
  end

  def amount
    @amount
  end

  def ==(other)
    currency == other.currency && amount == other.amount
  end

  def to(other_currency)
    Money.new(other_currency, @amount) * @currency.get_rate(other_currency)
  end

  def +(other)
    Money.new(@currency, @amount + other.to(@currency).amount)
  end

  def *(multiplier)
    Money.new(@currency, @amount * multiplier)
  end

  def to_s
    "#{ @amount } #{ @currency }"
  end
end