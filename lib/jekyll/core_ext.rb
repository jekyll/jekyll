class Hash
  # Merges self with another hash, recursively.
  #
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  #
  # Thanks to whoever made it.
  def deep_merge(hash)
    target = dup

    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        target[key] = target[key].deep_merge(hash[key])
        next
      end

      target[key] = hash[key]
    end

    target
  end

  # Read array from the supplied hash favouring the singular key
  # and then the plural key, and handling any nil entries.
  #   +hash+ the hash to read from
  #   +singular_key+ the singular key
  #   +plural_key+ the plural key
  #
  # Returns an array
  def pluralized_array(singular_key, plural_key)
    hash = self
    if hash.has_key?(singular_key)
      array = [hash[singular_key]] if hash[singular_key]
    elsif hash.has_key?(plural_key)
      case hash[plural_key]
      when String
        array = hash[plural_key].split
      when Array
        array = hash[plural_key].compact
      end
    end
    array || []
  end

  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  def symbolize_keys
    dup.symbolize_keys!
  end
end

# Thanks, ActiveSupport!
class Date
  # Converts datetime to an appropriate format for use in XML
  def xmlschema
    strftime("%Y-%m-%dT%H:%M:%S%Z")
  end if RUBY_VERSION < '1.9'
end

module Enumerable
  # Returns true if path matches against any glob pattern.
  # Look for more detail about glob pattern in method File::fnmatch.
  def glob_include?(e)
    any? { |exp| File.fnmatch?(exp, e) }
  end
end

# Ruby 1.8's File.read don't support option.
# read_with_options ignore optional parameter for 1.8,
# and act as alias for 1.9 or later.
class File
  if RUBY_VERSION < '1.9'
    def self.read_with_options(path, opts = {})
      self.read(path)
    end
  else
    def self.read_with_options(path, opts = {})
      self.read(path, opts)
    end
  end
end
