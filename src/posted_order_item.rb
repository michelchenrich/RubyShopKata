require_relative 'order_item.rb'

class PostedOrderItem
  def initialize(item, currency)
    @item = item
    @total = item.total.to(currency)
  end

  def total
    @total
  end

  def revert
    @item.put_units_in_stock
    @item
  end
end