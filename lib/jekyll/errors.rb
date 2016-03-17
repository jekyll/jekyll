module Jekyll
  module Errors
    FatalException = Class.new(::RuntimeError)

    # Errors for commands
    UnhealthySiteError = Class.new(FatalException)

    # Configuration errors
    InvalidConfigurationError = Class.new(FatalException)
    InvalidFileFormatError    = Class.new(FatalException)

    # IO Errors
    FileNotFoundError = Class.new(FatalException)

    # Render errors
    DropMutationException       = Class.new(FatalException)
    InvalidPermalinkError       = Class.new(FatalException)
    InvalidYAMLFrontMatterError = Class.new(FatalException)
    MissingDependencyError      = Class.new(FatalException)
    IncorrectDependencyError    = Class.new(FatalException)
    ConversionError             = Class.new(FatalException)
    LiquidRenderError           = Class.new(FatalException)

    # post_url tag errors
    InvalidDateError = Class.new(FatalException)
    InvalidPostNameError = Class.new(FatalException)
    PostURLError = Class.new(FatalException)
  end
end
