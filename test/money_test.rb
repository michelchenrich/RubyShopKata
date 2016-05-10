require 'test/unit'
require_relative '../src/money.rb'
require_relative '../src/currency.rb'

class MoneyTest < Test::Unit::TestCase
  def setup
    @currency = Currency.for(:CURRENCY)
    @other_currency = Currency.for(:OTHER)
    @currency.set_rate(2.0, @other_currency)
  end

  def test_monies_are_equal_when_they_have_the_same_currency_and_amount
    assert_equal(@currency.money(10), @currency.money(10))
    assert_not_equal(@other_currency.money(10), @currency.money(10))
    assert_not_equal(@currency.money(10.1), @currency.money(10))
  end

  def test_money_uses_exchange_rate_to_convert_to_other_currency
    assert_equal(@other_currency.money(20.0), @currency.money(10.0).to(@other_currency))
  end

  def test_string_prints_amount_followed_by_currency
    assert_equal('50.0 CURRENCY', @currency.money(50.0).to_s)
  end

  def test_multiplication
    assert_equal(@currency.money(50.0), @currency.money(10.0) * 5)
  end

  def test_sum_of_monies
    assert_equal(@currency.money(20.0), @currency.money(10.0) + @currency.money(10.0))
  end

  def test_sum_of_money_from_other_currency
    assert_equal(@currency.money(20.0), @currency.money(10.0) + @other_currency.money(20.0))
  end
end