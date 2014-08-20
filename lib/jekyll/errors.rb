module Jekyll
  module Errors
    class FatalException < RuntimeError
    end

    class MissingDependencyException < FatalException
    end
  end
end
