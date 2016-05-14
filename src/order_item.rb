require_relative 'posted_order_item.rb'

class OrderItem
  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end

  def total
    @product.price * @quantity
  end

  def put_units_in_stock
    @product.put_units(@quantity)
  end

  def post(currency)
    @product.take_units(@quantity)
    PostedOrderItem.new(self, currency)
  end
end