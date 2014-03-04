module Jekyll
  module Utils
    class << self

      # Merges a master hash with another hash, recursively.
      #
      # master_hash - the "parent" hash whose values will be overridden
      # other_hash  - the other hash whose values will be persisted after the merge
      #
      # This code was lovingly stolen from some random gem:
      # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
      #
      # Thanks to whoever made it.
      def deep_merge_hashes(master_hash, other_hash)
        target = master_hash.dup

        other_hash.keys.each do |key|
          if other_hash[key].is_a? Hash and target[key].is_a? Hash
            target[key] = Utils.deep_merge_hashes(target[key], other_hash[key])
            next
          end

          target[key] = other_hash[key]
        end

        target
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

      # Apply #to_sym to all keys in the hash
      #
      # hash - the hash to which to apply this transformation
      #
      # Returns a new hash with symbolized keys
      def symbolize_hash_keys(hash)
        target = hash.dup
        target.keys.each do |key|
          target[(key.to_sym rescue key) || key] = target.delete(key)
        end
        target
      end

      # Apply #to_s to all keys in the Hash
      #
      # hash - the hash to which to apply this transformation
      #
      # Returns a new hash with stringified keys
      def stringify_hash_keys(hash)
        target = hash.dup
        target.keys.each do |key|
          target[(key.to_s rescue key) || key] = target.delete(key)
        end
        target
      end

    end
  end
end
