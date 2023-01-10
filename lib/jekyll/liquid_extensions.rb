# frozen_string_literal: true

module Jekyll
  module LiquidExtensions
    # Lookup a Liquid variable in the given context.
    #
    # context  - the Liquid context in question.
    # variable - the variable name, as a string.
    #
    # Returns the value of the variable in the context
    #   or the variable name if not found.
    def lookup_variable(context, variable)
      lookup = context

      variable.split(".").each do |value|
        lookup = lookup[value]
      end

      lookup || variable
    end
  end
end

return if RUBY_VERSION < "3.2.0"

module Liquid
  class Variable
    # Do nothing since *tainting* is no longer a concept in Ruby.
    def taint_check(_context, _obj); end
  end

  module StandardFilters
    def escape(input)
      # Removes call to #untaint for Ruby 3.2 support.
      CGI.escapeHTML(input.to_s) unless input.nil?
    end
  end
end
