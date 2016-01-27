module Jekyll
  module Errors
    FatalException = Class.new(::RuntimeError)

    DropMutationException       = Class.new(FatalException)
    InvalidPermalinkError       = Class.new(FatalException)
    InvalidYAMLFrontMatterError = Class.new(FatalException)
    MissingDependencyException  = Class.new(FatalException)
  end
end
