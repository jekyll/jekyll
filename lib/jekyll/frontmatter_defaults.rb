# frozen_string_literal: true

module Jekyll
  # This class handles custom defaults for YAML frontmatter settings.
  # These are set in _config.yml and apply both to internal use (e.g. layout)
  # and the data available to liquid.
  #
  # It is exposed via the frontmatter_defaults method on the site class.
  class FrontmatterDefaults
    # Initializes a new instance.
    def initialize(site)
      @site = site
    end

    def update_deprecated_types(set)
      return set unless set.key?("scope") && set["scope"].key?("type")

      set["scope"]["type"] =
        case set["scope"]["type"]
        when "page"
          Deprecator.defaults_deprecate_type("page", "pages")
          "pages"
        when "post"
          Deprecator.defaults_deprecate_type("post", "posts")
          "posts"
        when "draft"
          Deprecator.defaults_deprecate_type("draft", "drafts")
          "drafts"
        else
          set["scope"]["type"]
        end

      set
    end

    def ensure_time!(set)
      return set unless set.key?("values") && set["values"].key?("date")
      return set if set["values"]["date"].is_a?(Time)
      set["values"]["date"] = Utils.parse_date(
        set["values"]["date"],
        "An invalid date format was found in a front-matter default set: #{set}"
      )
      set
    end

    # Finds a default value for a given setting, filtered by path and type
    #
    # path - the path (relative to the source) of the page,
    # post or :draft the default is used in
    # type - a symbol indicating whether a :page,
    # a :post or a :draft calls this method
    #
    # Returns the default value or nil if none was found
    def find(path, type, setting)
      value = nil
      old_scope = nil

      matching_sets(path, type).each do |set|
        if set["values"].key?(setting) && has_precedence?(old_scope, set["scope"])
          value = set["values"][setting]
          old_scope = set["scope"]
        end
      end
      value
    end

    # Collects a hash with all default values for a page or post
    #
    # path - the relative path of the page or post
    # type - a symbol indicating the type (:post, :page or :draft)
    #
    # Returns a hash with all default values (an empty hash if there are none)
    def all(path, type)
      defaults = {}
      old_scope = nil
      matching_sets(path, type).each do |set|
        if has_precedence?(old_scope, set["scope"])
          defaults = Utils.deep_merge_hashes(defaults, set["values"])
          old_scope = set["scope"]
        else
          defaults = Utils.deep_merge_hashes(set["values"], defaults)
        end
      end
      defaults
    end

    private

    # Checks if a given default setting scope matches the given path and type
    #
    # scope - the hash indicating the scope, as defined in _config.yml
    # path - the path to check for
    # type - the type (:post, :page or :draft) to check for
    #
    # Returns true if the scope applies to the given path and type
    def applies?(scope, path, type)
      applies_path?(scope, path) && applies_type?(scope, type)
    end

    def applies_path?(scope, path)
      return true if !scope.key?("path") || scope["path"].empty?

      sanitized_path = Pathname.new(sanitize_path(path))

      site_path = Pathname.new(@site.source)
      rel_scope_path = Pathname.new(scope["path"])
      abs_scope_path = File.join(@site.source, rel_scope_path)
      Dir.glob(abs_scope_path).each do |scope_path|
        scope_path = Pathname.new(scope_path).relative_path_from site_path
        return true if path_is_subpath?(sanitized_path, scope_path)
      end

      path_is_subpath?(sanitized_path, rel_scope_path)
    end

    def path_is_subpath?(path, parent_path)
      path.ascend do |ascended_path|
        if ascended_path.to_s == parent_path.to_s
          return true
        end
      end

      false
    end

    # Determines whether the scope applies to type.
    # The scope applies to the type if:
    #   1. no 'type' is specified
    #   2. the 'type' in the scope is the same as the type asked about
    #
    # scope - the Hash defaults set being asked about application
    # type  - the type of the document being processed / asked about
    #         its defaults.
    #
    # Returns true if either of the above conditions are satisfied,
    #   otherwise returns false
    def applies_type?(scope, type)
      !scope.key?("type") || scope["type"].eql?(type.to_s)
    end

    # Checks if a given set of default values is valid
    #
    # set - the default value hash, as defined in _config.yml
    #
    # Returns true if the set is valid and can be used in this class
    def valid?(set)
      set.is_a?(Hash) && set["values"].is_a?(Hash)
    end

    # Determines if a new scope has precedence over an old one
    #
    # old_scope - the old scope hash, or nil if there's none
    # new_scope - the new scope hash
    #
    # Returns true if the new scope has precedence over the older
    # rubocop: disable PredicateName
    def has_precedence?(old_scope, new_scope)
      return true if old_scope.nil?

      new_path = sanitize_path(new_scope["path"])
      old_path = sanitize_path(old_scope["path"])

      if new_path.length != old_path.length
        new_path.length >= old_path.length
      elsif new_scope.key?("type")
        true
      else
        !old_scope.key? "type"
      end
    end
    # rubocop: enable PredicateName

    # Collects a list of sets that match the given path and type
    #
    # Returns an array of hashes
    def matching_sets(path, type)
      valid_sets.select do |set|
        !set.key?("scope") || applies?(set["scope"], path, type)
      end
    end

    # Returns a list of valid sets
    #
    # This is not cached to allow plugins to modify the configuration
    # and have their changes take effect
    #
    # Returns an array of hashes
    def valid_sets
      sets = @site.config["defaults"]
      return [] unless sets.is_a?(Array)

      sets.map do |set|
        if valid?(set)
          ensure_time!(update_deprecated_types(set))
        else
          Jekyll.logger.warn "Defaults:", "An invalid front-matter default set was found:"
          Jekyll.logger.warn set.to_s
          nil
        end
      end.compact
    end

    # Sanitizes the given path by removing a leading and adding a trailing slash
    def sanitize_path(path)
      if path.nil? || path.empty?
        ""
      else
        path.gsub(%r!\A/|(?<=[^/])\z!, "".freeze)
      end
    end
  end
end
