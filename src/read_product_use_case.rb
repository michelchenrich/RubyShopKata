class ReadProductUseCase
  def self.builder
    Builder.new
  end
  
  def initialize(event_log, id)
    @event_log = event_log
    @id = id
  end
  
  def execute
    product = @event_log.playback(@id)
    {name: product.name, price: product.price.to_s, available_units: product.available_units}
  end

  class Builder
    def event_log=(event_log)
      @event_log = event_log
    end

    def id=(id)
      @id = id
    end

    def build
      ReadProductUseCase.new(@event_log, @id)
    end
  end
end
