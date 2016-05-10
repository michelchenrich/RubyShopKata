require 'test/unit'
require_relative '../src/product.rb'

class ProductTest < Test::Unit::TestCase
  def test_attributes
    product = Product.new('Product name', 10.0)
    assert_equal('Product name', product.name)
    assert_equal(10.0, product.price)
  end
end