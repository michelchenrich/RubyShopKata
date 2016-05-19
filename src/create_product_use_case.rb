require_relative 'currency.rb'
require_relative 'product.rb'
require 'securerandom'

class CreateProductUseCase
  def self.builder
    Builder.new
  end

  def initialize(event_log, name, price, available_units)
    @event_log = event_log
    @name = name
    @price = price
    @available_units = available_units
  end

  def execute
    id = SecureRandom.uuid
    @event_log.register(id, CreateProductCommand.new)
    @event_log.register(id, SetProductNameCommand.new(@name))
    @event_log.register(id, SetProductPriceCommand.new(@price))
    @event_log.register(id, PutUnitsToProductCommand.new(@available_units))
    {id: id}
  end

  class CreateProductCommand
    def apply_to(ignored)
      Product.new
    end
  end

  class SetProductNameCommand
    def initialize(name)
      @name = name
    end
    
    def apply_to(product)
      product.name = @name
      product
    end
  end

  class SetProductPriceCommand
    def initialize(price)
      @price = price
    end

    def apply_to(product)
      product.price = @price
      product
    end
  end

  class PutUnitsToProductCommand
    def initialize(units)
      @units = units
    end
    
    def apply_to(product)
      product.put_units(@units)
      product
    end
  end

  class Builder
    def event_log=(event_log)
      @event_log = event_log
    end

    def name=(name)
      @name = name
    end

    def price=(price)
      @price = price
    end
    
    def currency=(currency)
      @currency = currency
    end
    
    def available_units=(available_units)
      @available_units = available_units
    end

    def build
      CreateProductUseCase.new(@event_log, @name, Currency.for(@currency).money(@price), @available_units)
    end
  end
end
