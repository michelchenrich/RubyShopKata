require 'test/unit'
require_relative '../src/product.rb'
require_relative '../src/order_item.rb'

class OrderItemTest < Test::Unit::TestCase
  def test_attributes
    product = Product.new('Product name', 10.0)
    item = OrderItem.new(product, 10)
    assert_equal(product, item.product)
    assert_equal(100.0, item.total)
  end
end