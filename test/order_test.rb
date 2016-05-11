require 'test/unit'
require_relative '../src/currency.rb'
require_relative '../src/product.rb'
require_relative '../src/order.rb'

class OrderTest < Test::Unit::TestCase
  def currency
    Currency.for(:USD)
  end

  def other_currency
    Currency.for(:EUR)
  end

  def order
    @order
  end

  def product_of_price(amount, currency=self.currency)
    product = Product.new('Product', currency.money(amount))
    product.put_units(500)
    product
  end

  def setup
    @order = Order.new(currency)
  end

  def test_empty_has_zero_total
    assert_equal(currency.money(0.0), order.total)
  end

  def test_total_with_one_item_of_one_product
    order.add_item(product_of_price(10.0))
    assert_equal(currency.money(10.0), order.total)
  end

  def test_multiplies_price_by_quantity
    order.add_item(product_of_price(10.0), 2.0)
    assert_equal(currency.money(20.0), order.total)
  end

  def test_total_sums_prices_of_two_items
    order.add_item(product_of_price(10.0))
    order.add_item(product_of_price(5.0))
    assert_equal(currency.money(15.0), order.total)
  end

  def test_converts_price_to_its_currency
    order.add_item(product_of_price(10.0, other_currency))
    other_currency.set_rate(10.0, currency)
    assert_equal(currency.money(100.0), order.total)
  end

  def test_sums_prices_in_different_currencies
    order.add_item(product_of_price(5.0), 10.0)
    order.add_item(product_of_price(10.0, other_currency), 20.0)
    order.add_item(product_of_price(15.0, other_currency), 30.0)
    other_currency.set_rate(2.0, currency)
    assert_equal(currency.money(((5.0 * 10.0) + (10.0 * 20.0 * 2.0) + (15.0 * 30.0 * 2.0))), order.total)
  end

  def test_product_unit_is_not_taken_before_posting
    product = Product.new('', currency.money)
    product.put_units(1)
    order.add_item(product)
    assert_equal(1, product.available_units)
  end

  def test_product_unit_is_taken_after_posting
    product = Product.new('', currency.money)
    product.put_units(1)
    order.add_item(product)
    order.post
    assert_equal(0, product.available_units)
  end

  def test_product_units_from_item_quantity
    product = Product.new('', currency.money)
    product.put_units(10)
    order.add_item(product, 5)
    order.post
    assert_equal(5, product.available_units)
  end
end