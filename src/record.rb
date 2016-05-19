require 'securerandom'
require_relative 'decorator.rb'

class Record < Decorator
  @uuid_source = SecureRandom

  def self.uuid_source
    @uuid_source
  end

  def self.uuid_source=(uuid_source)
    @uuid_source = uuid_source
  end

  def initialize(entity, id=Record.uuid_source.uuid)
    super(entity)
    @entity = entity
    @id = id
  end

  def id
    @id
  end

  def entity
    @entity
  end
end
