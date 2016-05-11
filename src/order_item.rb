class OrderItem
  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end

  def product
    @product
  end

  def total
    @product.price * @quantity
  end

  def post
    @product.take_units(@quantity)
  end
end