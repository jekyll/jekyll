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
