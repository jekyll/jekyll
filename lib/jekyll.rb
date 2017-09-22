# frozen_string_literal: true

$LOAD_PATH.unshift __dir__ # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(__dir__, path, "*.rb")
  Dir[glob].sort.each do |f|
    require f
  end
end

# rubygems
require "rubygems"

# stdlib
require "pathutil"
require "forwardable"
require "fileutils"
require "time"
require "English"
require "pathname"
require "logger"
require "set"

# 3rd party
require "safe_yaml/load"
require "liquid"
require "kramdown"
require "colorator"

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll
  # internal requires
  autoload :Cleaner,             "jekyll/cleaner"
  autoload :Collection,          "jekyll/collection"
  autoload :Configuration,       "jekyll/configuration"
  autoload :Convertible,         "jekyll/convertible"
  autoload :Deprecator,          "jekyll/deprecator"
  autoload :Document,            "jekyll/document"
  autoload :EntryFilter,         "jekyll/entry_filter"
  autoload :Errors,              "jekyll/errors"
  autoload :Excerpt,             "jekyll/excerpt"
  autoload :External,            "jekyll/external"
  autoload :FrontmatterDefaults, "jekyll/frontmatter_defaults"
  autoload :Hooks,               "jekyll/hooks"
  autoload :Layout,              "jekyll/layout"
  autoload :CollectionReader,    "jekyll/readers/collection_reader"
  autoload :DataReader,          "jekyll/readers/data_reader"
  autoload :LayoutReader,        "jekyll/readers/layout_reader"
  autoload :PostReader,          "jekyll/readers/post_reader"
  autoload :PageReader,          "jekyll/readers/page_reader"
  autoload :StaticFileReader,    "jekyll/readers/static_file_reader"
  autoload :ThemeAssetsReader,   "jekyll/readers/theme_assets_reader"
  autoload :LogAdapter,          "jekyll/log_adapter"
  autoload :Page,                "jekyll/page"
  autoload :PluginManager,       "jekyll/plugin_manager"
  autoload :Publisher,           "jekyll/publisher"
  autoload :Reader,              "jekyll/reader"
  autoload :Regenerator,         "jekyll/regenerator"
  autoload :RelatedPosts,        "jekyll/related_posts"
  autoload :Renderer,            "jekyll/renderer"
  autoload :LiquidRenderer,      "jekyll/liquid_renderer"
  autoload :Site,                "jekyll/site"
  autoload :StaticFile,          "jekyll/static_file"
  autoload :Stevenson,           "jekyll/stevenson"
  autoload :Theme,               "jekyll/theme"
  autoload :ThemeBuilder,        "jekyll/theme_builder"
  autoload :URL,                 "jekyll/url"
  autoload :Utils,               "jekyll/utils"
  autoload :VERSION,             "jekyll/version"

  # extensions
  require "jekyll/plugin"
  require "jekyll/converter"
  require "jekyll/generator"
  require "jekyll/command"
  require "jekyll/liquid_extensions"
  require "jekyll/filters"

  class << self
    # Public: Tells you which Jekyll environment you are building in so you can skip tasks
    # if you need to.  This is useful when doing expensive compression tasks on css and
    # images and allows you to skip that when working in development.

    def env
      ENV["JEKYLL_ENV"] || "development"
    end

    # Public: Generate a Jekyll configuration Hash by merging the default
    # options with anything in _config.yml, and adding the given options on top.
    #
    # override - A Hash of config directives that override any options in both
    #            the defaults and the config file.
    #            See Jekyll::Configuration::DEFAULTS for a
    #            list of option names and their defaults.
    #
    # Returns the final configuration Hash.
    def configuration(override = {})
      config = Configuration.new
      override = Configuration[override].stringify_keys
      unless override.delete("skip_config_files")
        config = config.read_config_files(config.config_files(override))
      end

      # Merge DEFAULTS < _config.yml < override
      Configuration.from(Utils.deep_merge_hashes(config, override)).tap do |obj|
        set_timezone(obj["timezone"]) if obj["timezone"]
      end
    end

    # Public: Set the TZ environment variable to use the timezone specified
    #
    # timezone - the IANA Time Zone
    #
    # Returns nothing
    # rubocop:disable Naming/AccessorMethodName
    def set_timezone(timezone)
      ENV["TZ"] = if Utils::Platforms.really_windows?
                    Utils::WinTZ.calculate(timezone)
                  else
                    timezone
                  end
    end
    # rubocop:enable Naming/AccessorMethodName

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    def logger
      @logger ||= LogAdapter.new(Stevenson.new, (ENV["JEKYLL_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: Set the log writer.
    #         New log writer must respond to the same methods
    #         as Ruby's interal Logger.
    #
    # writer - the new Logger-compatible log transport
    #
    # Returns the new logger.
    def logger=(writer)
      @logger = LogAdapter.new(writer, (ENV["JEKYLL_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: An array of sites
    #
    # Returns the Jekyll sites created.
    def sites
      @sites ||= []
    end

    # Public: Ensures the questionable path is prefixed with the base directory
    #         and prepends the questionable path with the base directory if false.
    #
    # base_directory - the directory with which to prefix the questionable path
    # questionable_path - the path we're unsure about, and want prefixed
    #
    # Returns the sanitized path.
    def sanitized_path(base_directory, questionable_path)
      return base_directory if base_directory.eql?(questionable_path)

      clean_path = questionable_path.dup
      clean_path.insert(0, "/") if clean_path.start_with?("~")
      clean_path = File.expand_path(clean_path, "/")

      return clean_path if clean_path.eql?(base_directory)

      if clean_path.start_with?(base_directory.sub(%r!\z!, "/"))
        clean_path
      else
        clean_path.sub!(%r!\A\w:/!, "/")
        File.join(base_directory, clean_path)
      end
    end

    # Conditional optimizations
    Jekyll::External.require_if_present("liquid-c")
  end
end

require "jekyll/drops/drop"
require "jekyll/drops/document_drop"
require_all "jekyll/commands"
require_all "jekyll/converters"
require_all "jekyll/converters/markdown"
require_all "jekyll/drops"
require_all "jekyll/generators"
require_all "jekyll/tags"

require "jekyll-sass-converter"
