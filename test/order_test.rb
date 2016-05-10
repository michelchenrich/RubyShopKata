require 'test/unit'
require_relative '../src/currency.rb'
require_relative '../src/product.rb'
require_relative '../src/order.rb'

class OrderTest < Test::Unit::TestCase
  def setup
    @dollar = Currency.for(:USD)
    @euro = Currency.for(:EUR)
    @euro.set_rate(2.0, @dollar)

    @order = Order.new
    @order.currency = @dollar
  end

  def test_empty_has_zero_total
    @order.currency = @dollar
    assert_equal(@dollar.money(0.0), @order.total)
  end


  def test_total_with_one_item_of_one_product
    @order.add_item(Product.new('Product', @dollar.money(10.0)), 1.0)
    assert_equal(@dollar.money(10.0), @order.total)
  end

  def test_multiplies_price_by_quantity
    @order.add_item(Product.new('Product', @dollar.money(10.0)), 10.0)
    assert_equal(@dollar.money(100.0), @order.total)
  end

  def test_total_sums_prices_of_two_items
    @order.add_item(Product.new('Product 1', @dollar.money(10.0)), 1.0)
    @order.add_item(Product.new('Product 2', @dollar.money(5.0)), 1.0)
    assert_equal(@dollar.money(15.0), @order.total)
  end

  def test_empty_has_zero_total_in_other_currency
    @order.currency = @euro
    assert_equal(@euro.money(0.0), @order.total)
  end

  def test_converts_price_to_its_currency
    @order.add_item(Product.new('Product', @euro.money(10.0)), 1.0)
    assert_equal(@dollar.money(20.0), @order.total)
  end

  def test_acceptance
    @order.add_item(Product.new('Goose Islands American Pale Ale', @dollar.money(11.0)), 10.0)
    @order.add_item(Product.new('Paulaner Weißbier', @euro.money(10.0)), 20.0)
    @order.add_item(Product.new('Oktoberfest Pils', @euro.money(9.0)), 30.0)
    @order.currency = @dollar
    assert_equal(@dollar.money(1050.0), @order.total)
  end
end