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
end

# Thanks, ActiveSupport!
class Date
  # Converts datetime to an appropriate format for use in XML
  def xmlschema
    strftime("%Y-%m-%dT%H:%M:%S%Z")
  end if RUBY_VERSION < '1.9'
end
