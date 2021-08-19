# frozen_string_literal: true

require "psych"

module Jekyll
  module YAML
    class << self
      def safe_load(string)
        Psych.safe_load(string, :permitted_classes => [Date, Time])
      rescue ArgumentError
        # Psych versions < 3.1 had a different safe_load API and used
        # problematic language.
        Psych.safe_load(string, [Date, Time])
      end

      def load_file(filename, read_opts = {})
        safe_load File.read(filename, **read_opts)
      end
    end
  end
end
