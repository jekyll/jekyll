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

    class << self
      # Wraps `File.join` to cache the frozen result.
      # Reassigns `nil`, empty strings and empty arrays to a frozen empty string beforehand.
      #
      # Returns a frozen string.
      def join(base, item)
        base = "" if base.nil? || base.empty?
        item = "" if item.nil? || item.empty?
        @join ||= {}
        @join[base] ||= {}
        @join[base][item] ||= File.join(base, item).freeze
      end

      # Ensures the questionable path is prefixed with the base directory
      # and prepends the questionable path with the base directory if false.
      #
      # Returns a frozen string.
      def sanitized_path(base_directory, questionable_path)
        @sanitized_path ||= {}
        @sanitized_path[base_directory] ||= {}
        @sanitized_path[base_directory][questionable_path] ||= begin
          if questionable_path.nil?
            base_directory.freeze
          else
            sanitize_and_join(base_directory, questionable_path).freeze
          end
        end
      end

      private

      def sanitize_and_join(base_directory, questionable_path)
        clean_path = if questionable_path.start_with?("~")
                       questionable_path.dup.insert(0, "/")
                     else
                       questionable_path
                     end
        clean_path = File.expand_path(clean_path, "/")
        return clean_path if clean_path.eql?(base_directory)

        # remove any remaining extra leading slashes not stripped away by calling
        # `File.expand_path` above.
        clean_path.squeeze!("/")
        return clean_path if clean_path.start_with?(slashed_dir_cache(base_directory))

        clean_path.sub!(%r!\A\w:/!, "/")
        join(base_directory, clean_path)
      end

      def slashed_dir_cache(base_directory)
        @slashed_dir_cache ||= {}
        @slashed_dir_cache[base_directory] ||= base_directory.sub(%r!\z!, "/")
      end
    end
  end
end
