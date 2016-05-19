class Decorator
  def initialize(delegate)
    @delegate = delegate
  end

  def method_missing(name, *arguments, &block)
    @delegate.send(name, arguments, &block)
  end

  def respond_to?(message)
    @delegate.respond_to?(message)
  end
end
