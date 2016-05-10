require_relative 'order_item.rb'

class Order
  def initialize
    @items = []
  end

  def add_item(product, quantity)
    @items << OrderItem.new(product, quantity)
  end

  def currency=(currency)
    @currency = currency
  end

  def total
    @items.reduce(@currency.money) { |total, item| total + item.total }
  end
end