require 'test/unit'
require_relative '../src/currency.rb'

class CurrencyTest < Test::Unit::TestCase
  def currency
    Currency.for(:CURRENCY)
  end

  def other_currency
    Currency.for(:OTHER_CURRENCY)
  end

  def unknown_currency
    Currency.for(:UNKNOWN_CURRENCY)
  end

  def test_currency_for_symbol_is_always_same
    assert_same(currency, currency)
  end

  def test_same_currency_is_equal
    assert_equal(currency, currency)
    assert_not_equal(other_currency, currency)
  end

  def test_rate_is_1_to_self
    assert_equal(1.0, currency.get_rate(currency))
  end

  def test_returns_set_rate
    other_currency.set_rate(2.0, currency)
    assert_equal(2.0, other_currency.get_rate(currency))
  end

  def test_returns_reverse_rate
    other_currency.set_rate(2.0, currency)
    assert_equal(0.5, currency.get_rate(other_currency))
  end

  def test_unknown_rate_raises_error
    assert_raise(UnknownRateError) { currency.get_rate(unknown_currency) }
  end

  def test_string_prints_symbol
    assert_equal('CURRENCY', currency.to_s)
  end

  def test_money_making_with_no_amount
    money = currency.money
    assert_equal(0.0, money.amount)
    assert_equal(currency, money.currency)
  end

  def test_money_making_with_given_amount
    money = currency.money(10.0)
    assert_equal(10.0, money.amount)
    assert_equal(currency, money.currency)
  end
end