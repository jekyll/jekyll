module Jekyll
  class LiquidHashWithArray < Hash
    def default_array
      raise ArgumentError, 'You should attach an Array to a LiquidHashArrayWithArray before using it'
    end

    def error_set_message
      "Cannot directly set an element in a #{self.class.name} using #{self.class.name}#[]=. "\
      "Use #{self.class.name}#store if you want to add a new key to the hash, "\
      "and #{self.class.name}#array.[]= if you want to add a new element to the array."
    end

    def array
      @array || default_array
    end

    def hash
      self
    end

    def attach(array)
      @array = array

      self
    end

    # apply to the array
    # FIXME: Document this
    # Don't use integer keys with those or you WILL have trouble
    # Use each_pair if you want old behavior
    def each(&block)
      array.each(&block)
    end

    def [](key)
      # apply to the array when using an integer
      if !self.has_key?(key) && key.is_a?(Integer)
        array[key]
      else
        # Or to the hash when havigating
        super
      end
    end

    # map applies to the hash, and returns a hash
    def map(&block)
      h = self.class.new
      self.each_pair do |k,v|
        h.store(k, yield(v))
      end

      h
    end

    # should not be called that frequently...
    # you could still use the store method if you want to get sure the Hash is targeted
    # FIXME: maybe we should output a little warning here
    def []=(key, value)
      raise ArgumentError, error_set_message
      # if key.is_a?(Integer)
      #   array[key] = value
      # else
      #   super
      # end
    end

    def inspect
      "#<Jekyll::LiquidHashArrayWithArray @hash=#{hash} @array=#{@array}>"
    end
  end
end
