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
        @sanitized_path[base_directory][questionable_path] ||= if questionable_path.nil?
                                                                 base_directory.freeze
                                                               else
                                                                 sanitize_and_join(
                                                                   base_directory, questionable_path
                                                                 ).freeze
                                                               end
      end

      private

      def sanitize_and_join(base_directory, questionable_path)
        # Validate input parameters
        return base_directory.freeze if questionable_path.nil? || questionable_path.empty?

        # First, check for any potentially malicious patterns
        if contains_path_traversal?(questionable_path)
          Jekyll.logger.warn "Path Sanitization:",
                             "Potential directory traversal attempt blocked: #{questionable_path}"
          return base_directory.freeze
        end

        clean_path = if questionable_path.start_with?("~")
                       questionable_path.dup.insert(0, "/")
                     else
                       questionable_path
                     end

        # Expand path and handle potential security issues
        clean_path = File.expand_path(clean_path, "/")
        return clean_path if clean_path.eql?(base_directory)

        # Remove any remaining extra leading slashes not stripped away by calling
        # `File.expand_path` above.
        clean_path.squeeze!("/")

        # Cache the slashed directory for performance
        slashed_base = slashed_dir_cache(base_directory)
        return clean_path if clean_path.start_with?(slashed_base)

        # Handle Windows drive letters more securely
        clean_path = sanitize_windows_path(clean_path)

        join(base_directory, clean_path)
      end

      # Check if path contains directory traversal attempts
      def contains_path_traversal?(path)
        return false if path.nil? || path.empty?

        # Check for various directory traversal patterns
        traversal_patterns = [
          %r{\.\.[\/\\]},    # ../ or ..\
          %r{[\/\\]\.\.$},   # ends with /.. or \..
          /%2e%2e/i,          # URL encoded ..
          /\x2e\x2e/,         # Hex encoded ..
        ]

        traversal_patterns.any? { |pattern| path.match?(pattern) }
      end

      # Sanitize Windows-specific path issues
      def sanitize_windows_path(path)
        # Handle Windows drive letters and UNC paths more securely
        if Jekyll::Utils::Platforms.really_windows?
          # Remove drive letters but preserve UNC paths
          path = path.sub(%r!\A[a-zA-Z]:/!, "/") unless path.start_with?("//", "\\\\")
        else
          # On non-Windows systems, just remove drive letter patterns
          path = path.sub(%r!\A\w:/!, "/")
        end
        path
      end

      def slashed_dir_cache(base_directory)
        @slashed_dir_cache ||= {}
        @slashed_dir_cache[base_directory] ||= base_directory.sub(%r!\z!, "/")
      end
    end
  end
end
