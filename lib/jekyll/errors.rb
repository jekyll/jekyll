module Jekyll
  module Errors
    FatalException = Class.new(::RuntimeError)

    MissingDependencyException = Class.new(FatalException)
    DropMutationException      = Class.new(FatalException)
  end
end
