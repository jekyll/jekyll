module Jekyll
  class DefaultLayouts

    # Public: Initialize a new layout default handling instance
    #
    # config - the configuration for the site this instance is used for
    def initialize(config)
      @config = config
    end

    # Public: Retrieve the default layout for a given path and type (post or page)
    #
    # path - the path to the source file, relative to the source dir
    # type - the type, either :post or :page
    #
    # Returns the default layout name or nil
    def find(path, type)
      layout = nil
      path.gsub!(/\A\//, '') # remove starting slash
      path.gsub!(/([^\/])\z/, '\1/') # add trailing slash

      if @config['layout_defaults'] and @config['layout_defaults'].is_a? Array
        @config['layout_defaults'].each do |hash|
          unless valid?(hash)
            raise "Invalid default layout specified (must include path and layout name)"
          end

          if applies?(path, type, hash) and (layout.nil? or has_precedence?(layout, hash))
            layout = hash
          end
        end
      end

      if layout.nil?
        nil
      else
        layout['layout']
      end
    end

    private

    # Private: Ensure a default layout setting has all the required keys
    #
    # layout - the hash representing the default layout setting
    #
    # Returns true if the hash has all the data
    def valid?(layout)
      layout.has_key? 'layout' and layout.has_key? 'path' # those must be specified, though path can be an empty string
    end

    # Private: Check whether a given default layout setting applies to the given post or page
    #
    # path - the path to the source file, relative to the source directory
    # type - :page or :post
    # layout - the layout default setting hash
    #
    # Returns true if the given setting applies to the post or page
    def applies?(path, type, layout)
      (layout['path'].empty? or path.start_with? layout['path']) and (not layout.has_key? 'type' or layout['type'] == type.to_s)
    end

    # Private: Check which of the given layout_default hashes has precedence
    #
    # old - the first of the two layout hashes
    # new - the second of the two layout hashes
    #
    # Returns true if the second hash has precedence
    def has_precedence?(old, new)
      old_length = old['path'].length
      new_length = new['path'].length

      new_length > old_length or (new_length == old_length and not old.has_key? 'type' and new.has_key? 'type')
    end
  end
end