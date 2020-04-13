# frozen_string_literal: true

module Jekyll
  module Converters
    # Identity converter. Returns same content as given.
    # For more info on converters see https://jekyllrb.com/docs/plugins/converters/
    class Identity < Converter
      safe true

      priority :lowest

      # Public: Does the given extension match this converter's list of acceptable extensions?
      # Takes one argument: the file's extension (including the dot).
      #
      # _ext - The String extension to check (not relevant here)
      #
      # Returns true since it always matches.
      def matches(_ext)
        true
      end

      # Public: The extension to be given to the output file (including the dot).
      #
      # ext - The String extension or original file.
      #
      # Returns The String output file extension.
      def output_ext(ext)
        ext
      end

      # Logic to do the content conversion.
      #
      # content - String content of file (without front matter).
      #
      # Returns a String of the converted content.
      def convert(content)
        content
      end
    end
  end
end
