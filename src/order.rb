require_relative 'order_item.rb'

class Order
  def initialize(currency)
    @currency = currency
    @items = Array.new
  end

  def add_item(product, quantity=1.0)
    @items << OrderItem.new(product, quantity)
  end

  def post
    @items.each { |each| each.post }
  end

  def total
    @items.reduce(@currency.money) { |total, item| total + item.total }
  end
end