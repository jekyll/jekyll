# frozen_string_literal: true

module Jekyll
  module Utils
    extend self
    autoload :Ansi, "jekyll/utils/ansi"
    autoload :Exec, "jekyll/utils/exec"
    autoload :Internet, "jekyll/utils/internet"
    autoload :Platforms, "jekyll/utils/platforms"
    autoload :ThreadEvent, "jekyll/utils/thread_event"
    autoload :WinTZ, "jekyll/utils/win_tz"

    # Constants for use in #slugify
    SLUGIFY_MODES = %w(raw default pretty ascii latin).freeze
    SLUGIFY_RAW_REGEXP = Regexp.new('\\s+').freeze
    SLUGIFY_DEFAULT_REGEXP = Regexp.new("[^\\p{M}\\p{L}\\p{Nd}]+").freeze
    SLUGIFY_PRETTY_REGEXP = Regexp.new("[^\\p{M}\\p{L}\\p{Nd}._~!$&'()+,;=@]+").freeze
    SLUGIFY_ASCII_REGEXP = Regexp.new("[^[A-Za-z0-9]]+").freeze

    # Takes a slug and turns it into a simple title.
    def titleize_slug(slug)
      slug.split("-").map!(&:capitalize).join(" ")
    end

    # Non-destructive version of deep_merge_hashes! See that method.
    #
    # Returns the merged hashes.
    def deep_merge_hashes(master_hash, other_hash)
      deep_merge_hashes!(master_hash.dup, other_hash)
    end

    # Merges a master hash with another hash, recursively.
    #
    # master_hash - the "parent" hash whose values will be overridden
    # other_hash  - the other hash whose values will be persisted after the merge
    #
    # This code was lovingly stolen from some random gem:
    # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
    #
    # Thanks to whoever made it.
    def deep_merge_hashes!(target, overwrite)
      merge_values(target, overwrite)
      merge_default_proc(target, overwrite)
      duplicate_frozen_values(target)

      target
    end

    def mergable?(value)
      value.is_a?(Hash) || value.is_a?(Drops::Drop)
    end

    def duplicable?(obj)
      case obj
      when nil, false, true, Symbol, Numeric
        false
      else
        true
      end
    end

    # Read array from the supplied hash favouring the singular key
    # and then the plural key, and handling any nil entries.
    #
    # hash - the hash to read from
    # singular_key - the singular key
    # plural_key - the plural key
    #
    # Returns an array
    def pluralized_array_from_hash(hash, singular_key, plural_key)
      array = []
      value = value_from_singular_key(hash, singular_key)
      value ||= value_from_plural_key(hash, plural_key)

      array << value
      array.flatten!
      array.compact!
      array
    end

    def value_from_singular_key(hash, key)
      hash[key] if hash.key?(key) || (hash.default_proc && hash[key])
    end

    def value_from_plural_key(hash, key)
      if hash.key?(key) || (hash.default_proc && hash[key])
        val = hash[key]
        case val
        when String
          val.split
        when Array
          val.compact
        end
      end
    end

    def transform_keys(hash)
      result = {}
      hash.each_key do |key|
        result[yield(key)] = hash[key]
      end
      result
    end

    # Apply #to_sym to all keys in the hash
    #
    # hash - the hash to which to apply this transformation
    #
    # Returns a new hash with symbolized keys
    def symbolize_hash_keys(hash)
      transform_keys(hash) { |key| key.to_sym rescue key }
    end

    # Apply #to_s to all keys in the Hash
    #
    # hash - the hash to which to apply this transformation
    #
    # Returns a new hash with stringified keys
    def stringify_hash_keys(hash)
      transform_keys(hash) { |key| key.to_s rescue key }
    end

    # Parse a date/time and throw an error if invalid
    #
    # input - the date/time to parse
    # msg - (optional) the error message to show the user
    #
    # Returns the parsed date if successful, throws a FatalException
    # if not
    def parse_date(input, msg = "Input could not be parsed.")
      @parse_date_cache ||= {}
      @parse_date_cache[input] ||= Time.parse(input).localtime
    rescue ArgumentError
      raise Errors::InvalidDateError, "Invalid date '#{input}': #{msg}"
    end

    # Determines whether a given file has
    #
    # Returns true if the YAML front matter is present.
    # rubocop: disable Naming/PredicateName
    def has_yaml_header?(file)
      File.open(file, "rb", &:readline).match? %r!\A---\s*\r?\n!
    rescue EOFError
      false
    end

    # Determine whether the given content string contains Liquid Tags or Variables
    #
    # Returns true is the string contains sequences of `{%` or `{{`
    def has_liquid_construct?(content)
      return false if content.nil? || content.empty?

      content.include?("{%") || content.include?("{{")
    end
    # rubocop: enable Naming/PredicateName

    # Slugify a filename or title.
    #
    # string - the filename or title to slugify
    # mode - how string is slugified
    # cased - whether to replace all uppercase letters with their
    # lowercase counterparts
    #
    # When mode is "none", return the given string.
    #
    # When mode is "raw", return the given string,
    # with every sequence of spaces characters replaced with a hyphen.
    #
    # When mode is "default" or nil, non-alphabetic characters are
    # replaced with a hyphen too.
    #
    # When mode is "pretty", some non-alphabetic characters (._~!$&'()+,;=@)
    # are not replaced with hyphen.
    #
    # When mode is "ascii", some everything else except ASCII characters
    # a-z (lowercase), A-Z (uppercase) and 0-9 (numbers) are not replaced with hyphen.
    #
    # When mode is "latin", the input string is first preprocessed so that
    # any letters with accents are replaced with the plain letter. Afterwards,
    # it follows the "default" mode of operation.
    #
    # If cased is true, all uppercase letters in the result string are
    # replaced with their lowercase counterparts.
    #
    # Examples:
    #   slugify("The _config.yml file")
    #   # => "the-config-yml-file"
    #
    #   slugify("The _config.yml file", "pretty")
    #   # => "the-_config.yml-file"
    #
    #   slugify("The _config.yml file", "pretty", true)
    #   # => "The-_config.yml file"
    #
    #   slugify("The _config.yml file", "ascii")
    #   # => "the-config-yml-file"
    #
    #   slugify("The _config.yml file", "latin")
    #   # => "the-config-yml-file"
    #
    # Returns the slugified string.
    def slugify(string, mode: nil, cased: false)
      mode ||= "default"
      return nil if string.nil?

      unless SLUGIFY_MODES.include?(mode)
        return cased ? string : string.downcase
      end

      # Drop accent marks from latin characters. Everything else turns to ?
      if mode == "latin"
        I18n.config.available_locales = :en if I18n.config.available_locales.empty?
        string = I18n.transliterate(string)
      end

      slug = replace_character_sequence_with_hyphen(string, :mode => mode)

      # Remove leading/trailing hyphen
      slug.gsub!(%r!^-|-$!i, "")

      slug.downcase! unless cased
      Jekyll.logger.warn("Warning:", "Empty `slug` generated for '#{string}'.") if slug.empty?
      slug
    end

    # Add an appropriate suffix to template so that it matches the specified
    # permalink style.
    #
    # template - permalink template without trailing slash or file extension
    # permalink_style - permalink style, either built-in or custom
    #
    # The returned permalink template will use the same ending style as
    # specified in permalink_style.  For example, if permalink_style contains a
    # trailing slash (or is :pretty, which indirectly has a trailing slash),
    # then so will the returned template.  If permalink_style has a trailing
    # ":output_ext" (or is :none, :date, or :ordinal) then so will the returned
    # template.  Otherwise, template will be returned without modification.
    #
    # Examples:
    #   add_permalink_suffix("/:basename", :pretty)
    #   # => "/:basename/"
    #
    #   add_permalink_suffix("/:basename", :date)
    #   # => "/:basename:output_ext"
    #
    #   add_permalink_suffix("/:basename", "/:year/:month/:title/")
    #   # => "/:basename/"
    #
    #   add_permalink_suffix("/:basename", "/:year/:month/:title")
    #   # => "/:basename"
    #
    # Returns the updated permalink template
    def add_permalink_suffix(template, permalink_style)
      template = template.dup

      case permalink_style
      when :pretty
        template << "/"
      when :date, :ordinal, :none
        template << ":output_ext"
      else
        template << "/" if permalink_style.to_s.end_with?("/")
        template << ":output_ext" if permalink_style.to_s.end_with?(":output_ext")
      end

      template
    end

    # Work the same way as Dir.glob but separating the input into two parts
    # ('dir' + '/' + 'pattern') to make sure the first part('dir') does not act
    # as a pattern.
    #
    # For example, Dir.glob("path[/*") always returns an empty array,
    # because the method fails to find the closing pattern to '[' which is ']'
    #
    # Examples:
    #   safe_glob("path[", "*")
    #   # => ["path[/file1", "path[/file2"]
    #
    #   safe_glob("path", "*", File::FNM_DOTMATCH)
    #   # => ["path/.", "path/..", "path/file1"]
    #
    #   safe_glob("path", ["**", "*"])
    #   # => ["path[/file1", "path[/folder/file2"]
    #
    # dir      - the dir where glob will be executed under
    #           (the dir will be included to each result)
    # patterns - the patterns (or the pattern) which will be applied under the dir
    # flags    - the flags which will be applied to the pattern
    #
    # Returns matched paths
    def safe_glob(dir, patterns, flags = 0)
      return [] unless Dir.exist?(dir)

      pattern = File.join(Array(patterns))
      return [dir] if pattern.empty?

      Dir.chdir(dir) do
        Dir.glob(pattern, flags).map { |f| File.join(dir, f) }
      end
    end

    # Returns merged option hash for File.read of self.site (if exists)
    # and a given param
    def merged_file_read_opts(site, opts)
      merged = (site ? site.file_read_opts : {}).merge(opts)

      # always use BOM when reading UTF-encoded files
      if merged[:encoding]&.downcase&.start_with?("utf-")
        merged[:encoding] = "bom|#{merged[:encoding]}"
      end
      if merged["encoding"]&.downcase&.start_with?("utf-")
        merged["encoding"] = "bom|#{merged["encoding"]}"
      end

      merged
    end

    private

    def merge_values(target, overwrite)
      target.merge!(overwrite) do |_key, old_val, new_val|
        if new_val.nil?
          old_val
        elsif mergable?(old_val) && mergable?(new_val)
          deep_merge_hashes(old_val, new_val)
        else
          new_val
        end
      end
    end

    def merge_default_proc(target, overwrite)
      if target.is_a?(Hash) && overwrite.is_a?(Hash) && target.default_proc.nil?
        target.default_proc = overwrite.default_proc
      end
    end

    def duplicate_frozen_values(target)
      target.each do |key, val|
        target[key] = val.dup if val.frozen? && duplicable?(val)
      end
    end

    # Replace each character sequence with a hyphen.
    #
    # See Utils#slugify for a description of the character sequence specified
    # by each mode.
    def replace_character_sequence_with_hyphen(string, mode: "default")
      replaceable_char =
        case mode
        when "raw"
          SLUGIFY_RAW_REGEXP
        when "pretty"
          # "._~!$&'()+,;=@" is human readable (not URI-escaped) in URL
          # and is allowed in both extN and NTFS.
          SLUGIFY_PRETTY_REGEXP
        when "ascii"
          # For web servers not being able to handle Unicode, the safe
          # method is to ditch anything else but latin letters and numeric
          # digits.
          SLUGIFY_ASCII_REGEXP
        else
          SLUGIFY_DEFAULT_REGEXP
        end

      # Strip according to the mode
      string.gsub(replaceable_char, "-")
    end
  end
end
