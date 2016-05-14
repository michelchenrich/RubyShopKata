require_relative 'order_item.rb'
require_relative 'posted_order.rb'

class Order
  def initialize(items=Array.new)
    @items = items
  end

  def add_item(product, quantity=1.0)
    @items << OrderItem.new(product, quantity)
  end

  def post(currency)
    PostedOrder.new(currency, @items.map { |each| each.post(currency) })
  end
end