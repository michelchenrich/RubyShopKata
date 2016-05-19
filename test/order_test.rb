require 'test/unit'
require_relative '../src/currency.rb'
require_relative '../src/product.rb'
require_relative '../src/order.rb'
require_relative '../src/posted_order.rb'

class OrderTest < Test::Unit::TestCase
  def currency
    Currency.for(:CURRENCY)
  end

  def other_currency
    Currency.for(:OTHER_CURRENCY)
  end

  def product_of_price(amount, currency=self.currency)
    product = Product.new('Product', currency.money(amount))
    product.put_units(500)
    product
  end

  def setup
    @order = Order.new
    other_currency.set_rate(2.0, currency)
  end

  def test_cannot_add_item_after_posting
    @order = @order.post(currency)
    assert_not_respond_to(@order, :add_item)
  end

  def test_cannot_post_twice
    @order = @order.post(currency)
    assert_not_respond_to(@order, :post)
  end

  def test_product_unit_is_not_taken_before_posting
    product = Product.new('', currency.money)
    product.put_units(1)
    @order.add_item(product)
    assert_equal(1, product.available_units)
  end

  def test_posting_takes_units_from_product
    product = Product.new('', currency.money)
    product.put_units(10)
    @order.add_item(product, 5)
    @order.post(currency)
    assert_equal(5, product.available_units)
  end

  def test_reverting_posted_restores_units_to_product
    product = Product.new('', currency.money)
    product.put_units(10)
    @order.add_item(product, 5)
    @order = @order.post(currency)
    @order.revert
    assert_equal(10, product.available_units)
  end

  def test_cannot_revert_twice
    @order = @order.post(currency).revert
    assert_not_respond_to(@order, :revert)
  end

  def test_no_total_before_posting
    assert_not_respond_to(@order, :total)
  end

  def test_empty_has_zero_total
    @order = @order.post(currency)
    assert_equal(currency.money(0.0), @order.total)
  end

  def test_total_with_one_item_of_one_product
    @order.add_item(product_of_price(10.0))
    @order = @order.post(currency)
    assert_equal(currency.money(10.0), @order.total)
  end

  def test_multiplies_price_by_quantity
    @order.add_item(product_of_price(10.0), 2.0)
    @order = @order.post(currency)
    assert_equal(currency.money(20.0), @order.total)
  end

  def test_total_sums_prices_of_two_items
    @order.add_item(product_of_price(10.0))
    @order.add_item(product_of_price(5.0))
    @order = @order.post(currency)
    assert_equal(currency.money(15.0), @order.total)
  end

  def test_converts_price_to_its_currency
    @order.add_item(product_of_price(10.0, other_currency))
    @order = @order.post(currency)
    assert_equal(currency.money(20.0), @order.total)
  end

  def test_sums_prices_in_different_currencies
    @order.add_item(product_of_price(10.0))
    @order.add_item(product_of_price(5.0, other_currency))
    @order = @order.post(currency)
    assert_equal(currency.money(10.0 + (5.0 * 2.0)), @order.total)
  end

  def test_new_exchange_rates_are_not_used_after_posting
    @order.add_item(product_of_price(5.0, other_currency))
    @order = @order.post(currency)
    other_currency.set_rate(3.0, currency)
    assert_equal(currency.money(5.0 * 2.0), @order.total)
  end

  def test_new_exchange_rates_are_used_after_reverting
    @order.add_item(product_of_price(5.0, other_currency))
    @order = @order.post(currency)
    other_currency.set_rate(3.0, currency)
    @order = @order.revert.post(currency)
    assert_equal(currency.money(5.0 * 3.0), @order.total)
  end

  def test_new_prices_are_not_used_after_posting
    product = Product.new('Name', currency.money(5.0))
    product.put_units(1.0)
    @order.add_item(product)
    @order = @order.post(currency)
    product.price = currency.money(6.0)
    assert_equal(currency.money(5.0), @order.total)
  end

  def test_new_prices_are_used_after_reverting
    product = Product.new('Name', currency.money(5.0))
    product.put_units(1.0)
    @order.add_item(product)
    @order = @order.post(currency)
    product.price = currency.money(6.0)
    @order = @order.revert.post(currency)
    assert_equal(currency.money(6.0), @order.total)
  end
end
