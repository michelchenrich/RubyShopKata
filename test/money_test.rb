require 'test/unit'
require_relative '../src/money.rb'
require_relative '../src/currency.rb'

class MoneyTest < Test::Unit::TestCase
  def currency
    Currency.for(:CURRENCY)
  end

  def other_currency
    Currency.for(:OTHER_CURRENCY)
  end

  def test_integer_amount_is_converted_to_float
    assert_same(Money.new(currency, 10).amount, 10.0)
  end

  def test_string_amount_is_converted_to_float
    assert_same(Money.new(currency, '10').amount, 10.0)
  end

  def test_monies_are_equal_when_they_have_the_same_currency_and_amount
    assert_equal(currency.money(10), currency.money(10))
    assert_not_equal(other_currency.money(10), currency.money(10))
    assert_not_equal(currency.money(10.1), currency.money(10))
  end

  def test_string_prints_amount_with_two_decimal_places_followed_by_currency
    assert_equal('50.12 CURRENCY', currency.money(50.123).to_s)
    assert_equal('49.90 OTHER_CURRENCY', other_currency.money(49.90).to_s)
  end

  def test_multiplication
    assert_equal(currency.money(50.0), currency.money(10.0) * 5)
  end

  def test_addition
    assert_equal(currency.money(20.0), currency.money(10.0) + currency.money(10.0))
  end

  def test_conversion_to_other_currency
    currency.set_rate(100.0, other_currency)
    assert_equal(other_currency.money(1000.0), currency.money(10.0).to(other_currency))
  end

  def test_addition_of_different_currencies_converting_to_addend
    currency.set_rate(3.0, other_currency)
    assert_equal(currency.money(20.0), currency.money(10.0) + other_currency.money(30.0))
  end
end