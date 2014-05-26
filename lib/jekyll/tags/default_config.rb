# Liquid Tag to output the default configuration for Jekyll. This tag
# is used primarily for the Jekyll documentation.
module Jekyll
  class DefaultConfigTag < Liquid::Tag

    def render(context)
      hash_to_string(Configuration::DEFAULTS)
    end

    private

    # Return a nicely formatted string representation of a hash
    def hash_to_string(hash, indentation=0)
      string = ''
      hash.each do |key, value|
        string << ' ' * indentation
        string << key.to_s << ': '
        string << if value.is_a? Hash
          "\n" << hash_to_string(value, indentation + 2)
        else
          value_to_string(value)
        end
        string << "\n"
      end
      string
    end

    # Return a formatted string for a value from the default
    # configuration. This contains the handling of edge cases
    # such as paths and strings with new line characters.
    def value_to_string(value)
      if value.is_a?(String)
        if value.include?("\n")
          value = value.inspect
        elsif (path = Pathname.new(value)) && path.absolute?
          value = path.relative_path_from(Pathname.new(Dir.pwd))
        end
      end

      value.to_s
    end

  end
end

Liquid::Template.register_tag('default_config', Jekyll::DefaultConfigTag)
