# frozen_string_literal: true

module Jekyll
  # A singleton class that caches frozen instances of path strings returned from its methods.
  #
  # NOTE:
  #   This class exists because `File.join` allocates an Array and returns a new String on every
  #   call using **the same arguments**. Caching the result means reduced memory usage.
  #   However, the caches are never flushed so that they can be used even when a site is
  #   regenerating. The results are frozen to deter mutation of the cached string.
  #
  #   Therefore, employ this class only for situations where caching the result is necessary
  #   for performance reasons.
  #
  class PathManager
    # This class cannot be initialized from outside
    private_class_method :new

    # Wraps `File.join` to cache the frozen result.
    # Reassigns `nil`, empty strings and empty arrays to a frozen empty string beforehand.
    #
    # Returns a frozen string.
    def self.join(base, item)
      base = "" if base.nil? || base.empty?
      item = "" if item.nil? || item.empty?
      @join ||= {}
      @join[base] ||= {}
      @join[base][item] ||= File.join(base, item).freeze
    end

    # Strips dots and extra slashes from `input` string, prefixes it with the given `base` path
    # via `self.join` and caches the frozen result.
    #
    # Returns a frozen string.
    def self.sanitized_join(base, input)
      @sanitized_join ||= {}
      @sanitized_join[base] ||= {}
      @sanitized_join[base][input] ||= begin
        input = input.dup
        input.insert(0, "/") if input.start_with?("~")
        input = File.expand_path(input, "/")

        if input.eql?(base)
          input.freeze
        else
          # remove any remaining extra leading slashes not stripped away by calling
          # `File.expand_path` above.
          input.squeeze!("/")

          if input.start_with?("#{base}/")
            input.freeze
          else
            input.sub!(%r!\A\w:/!, "/")
            join(base, input).freeze
          end
        end
      end
    end
  end
end
