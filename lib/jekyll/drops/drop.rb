# encoding: UTF-8

module Jekyll
  module Drops
    class Drop < Liquid::Drop
      # Get or set whether the drop class is mutable.
      # Mutability determines whether or not pre-defined fields may be
      # overwritten.
      #
      # is_mutable - Boolean set mutability of the class (default: nil)
      #
      # Returns the mutability of the class
      def self.mutable(is_mutable = nil)
        if is_mutable
          @is_mutable = is_mutable
        end
        @is_mutable || false
      end

      # Create a new Drop
      #
      # obj - the Jekyll Site, Collection, or Document required by the
      # drop.
      #
      # Returns nothing
      def initialize(obj)
        @obj = obj
        @mutations = {} # only if mutable: true
      end

      # Access a method in the Drop or a field in the underlying hash data.
      # If mutable, checks the mutations first. Then checks the methods,
      # and finally check the underlying hash (e.g. document front matter)
      # if all the previous places didn't match.
      #
      # key - the string key whose value to fetch
      #
      # Returns the value for the given key, or nil if none exists
      def [](key)
        if self.class.mutable && @mutations.key?(key)
          @mutations[key]
        elsif respond_to? key
          public_send key
        else
          fallback_data[key]
        end
      end

      # Set a field in the Drop. If mutable, sets in the mutations and
      # returns. If not mutable, checks first if it's trying to override a
      # Drop method and raises a DropMutationException if so. If not
      # mutable and the key is not a method on the Drop, then it sets the
      # key to the value in the underlying hash (e.g. document front
      # matter)
      #
      # key - the String key whose value to set
      # val - the Object to set the key's value to
      #
      # Returns the value the key was set to unless the Drop is not mutable
      # and the key matches a method in which case it raises a
      # DropMutationException.
      def []=(key, val)
        if self.class.mutable
          @mutations[key] = val
        elsif respond_to? key
          raise Errors::DropMutationException, "Key #{key} cannot be set in the drop."
        else
          fallback_data[key] = val
        end
      end

    end
  end
end
