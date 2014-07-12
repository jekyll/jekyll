module Jekyll
  class FatalException < StandardError
    class MissingDependencyException < FatalException
    end
  end
end
