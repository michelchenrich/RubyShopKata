require_relative 'not_enough_available_units_error'

class Product
  def initialize(name, price)
    @name = name
    @price = price
    @available_units = 0
  end

  def name
    @name
  end

  def price
    @price
  end

  def price=(money)
    @price = money
  end

  def available_units
    @available_units
  end

  def put_units(quantity)
    @available_units += quantity
  end

  def take_units(quantity)
    raise NotEnoughAvailableUnitsError if @available_units < quantity
    @available_units -= quantity
  end
end