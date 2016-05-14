require_relative 'order.rb'

class PostedOrder
  def initialize(currency, items)
    @currency = currency
    @items = items
  end

  def revert
    Order.new(@items.map { |each| each.revert })
  end

  def total
    @items.reduce(@currency.money) { |total, item| total + item.total }
  end
end