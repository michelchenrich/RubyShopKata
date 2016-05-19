require 'test/unit'
require_relative '../src/product.rb'
require_relative '../src/not_enough_available_units_error.rb'

class ProductTest < Test::Unit::TestCase
  def test_empty_product
    product = Product.new
    assert_equal(nil, product.name)
    assert_equal(nil, product.price)
  end
 
  def test_initial_name
    product = Product.new('Product name', 10.0)
    assert_equal('Product name', product.name)
  end

  def test_initial_price
    product = Product.new('Product name', 10.0)
    assert_equal(10.0, product.price)
  end

  def test_new_name
    product = Product.new('Old name', 10.0)
    product.name = 'New name'
    assert_equal('New name', product.name)
  end

  def test_new_price
    product = Product.new('Product name', 10.0)
    product.price = 20.0
    assert_equal(20.0, product.price)
  end

  def test_new_has_zero_available_units
    assert_equal(0, Product.new('Name', 0).available_units)
  end

  def test_increases_available_units
    product = Product.new('Name', 0)
    product.put_units(3)
    assert_equal(3, product.available_units)
  end

  def test_decreases_available_units
    product = Product.new('Name', 0)
    product.put_units(3)
    product.take_units(2)
    assert_equal(1, product.available_units)
  end

  def test_raises_error_when_decreasing_available_units_below_zero
    product = Product.new('Name', 0)
    assert_raise(NotEnoughAvailableUnitsError) { product.take_units(1) }
  end
end
