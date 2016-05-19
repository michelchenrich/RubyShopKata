require 'test/unit'
require_relative '../src/create_product_use_case.rb'
require_relative '../src/read_product_use_case.rb'

class CreateProductUseCaseTest < Test::Unit::TestCase
  def test_something_new
    event_log = InMemoryEventLog.new

    builder = CreateProductUseCase.builder
    builder.event_log = event_log
    builder.name = 'Product name'
    builder.price = '10.0'
    builder.currency = 'USD'
    builder.available_units = 10
    use_case = builder.build
    result = use_case.execute
    
    builder = ReadProductUseCase.builder
    builder.event_log = event_log
    builder.id = result[:id]
    use_case = builder.build
    result = use_case.execute
    
    assert_equal('Product name', result[:name])
    assert_equal('10.00 USD', result[:price])
    assert_equal(10, result[:available_units])
  end
  
  class InMemoryEventLog
    def initialize
      @events = Hash.new { |this, new_id| this[new_id] = Array.new }
    end

    def register(aggregate_id, event)
      @events[aggregate_id] << event 
    end

    def playback(aggregate_id)
      @events[aggregate_id].reduce(nil) { |entity, event| event.apply_to(entity) }
    end
  end
end
