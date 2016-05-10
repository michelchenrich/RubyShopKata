require 'test/unit'
require_relative '../src/currency.rb'

class CurrencyTest < Test::Unit::TestCase
  def test_currency_for_symbol_is_always_same
    assert_same(Currency.for(:USD), Currency.for(:USD))
  end

  def test_same_currency_is_equal
    assert_equal(Currency.for(:USD), Currency.for(:USD))
    assert_not_equal(Currency.for(:EUR), Currency.for(:USD))
  end

  def test_rate_is_1_to_self
    assert_equal(1.0, Currency.for(:USD).get_rate(Currency.for(:USD)))
  end

  def test_returns_set_rate
    Currency.for(:EUR).set_rate(2.0, Currency.for(:USD))
    assert_equal(2.0, Currency.for(:EUR).get_rate(Currency.for(:USD)))
  end

  def test_returns_reverse_rate
    Currency.for(:EUR).set_rate(2.0, Currency.for(:USD))
    assert_equal(0.5, Currency.for(:USD).get_rate(Currency.for(:EUR)))
  end

  def test_unknown_rate_raises_error
    assert_raise(UnknownRateError) { Currency.for(:USD).get_rate(Currency.for(:OTHER)) }
  end

  def test_string_prints_symbol
    assert_equal('USD', Currency.for(:USD).to_s)
  end

  def test_money_making_with_no_amount
    currency = Currency.for(:USD)
    money = currency.money
    assert_equal(0.0, money.amount)
    assert_equal(currency, money.currency)
  end

  def test_money_making_with_given_amount
    currency = Currency.for(:USD)
    money = currency.money(10.0)
    assert_equal(10.0, money.amount)
    assert_equal(currency, money.currency)
  end
end