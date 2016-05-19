require 'test/unit'
require_relative '../src/record.rb'

class RecordTest < Test::Unit::TestCase
  def setup
    @fake_uuid_source = FakeUUIDSource.new
    Record.uuid_source = @fake_uuid_source
  end

  def test_uses_uuid_source_when_no_id_is_given
    assert_not_equal(@fake_uuid_source.last_uuid, Record.new(nil).id)
  end

  def test_has_entity
    entity = Object.new
    record = Record.new(entity)
    assert_same(entity, record.entity)
  end

  def test_can_crate_with_entity_and_id
    record = Record.new(:entity, :id)
    assert_equal(:entity, record.entity)
    assert_equal(:id, record.id)
  end

  def test_responds_to_same_messages_as_entity
    entity = FakeEntity.new([:message_1, :message_3])
    record = Record.new(entity)
    assert_respond_to(record, :message_1)
    assert_not_respond_to(record, :message_2)
    assert_respond_to(record, :message_3)
  end

  def test_delegates_messages_to_entity
    entity = FakeEntity.new([:message_1, :message_3])
    record = Record.new(entity)
    record.message_1
    record.message_3
    assert_include(entity.messages, :message_1)
    assert_include(entity.messages, :message_3)
  end

  class FakeEntity
    def initialize(responds_to)
      @messages = Array.new
      @responds_to = responds_to.map { |each| each.to_sym }
    end

    def respond_to?(name)
      @responds_to.include?(name.to_sym)
    end

    def method_missing(name, *arguments, &block)
      @messages << name
    end

    def messages
      @messages
    end
  end

  class FakeUUIDSource
    def initialize
      @uuid = 1
    end

    def uuid
      @uuid += 1
    end
    
    def last_uuid
      @uuid
    end
  end
end
