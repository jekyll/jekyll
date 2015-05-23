module Jekyll
  class LiquidHashWithValues < LiquidHashWithArray
    def default_array
      self.values
    end

    def error_set_message
      "Cannot directly set an element in a #{self.class.name} using #{self.class.name}#[]=. "\
      "Use #{self.class.name}#store if you want to add a new key to the hash. "\
      "(Please note that in a #{self.class.name} the array is dynamic and can only be modified by editing the hash.)"
    end

    def to_liquid
      self.map{ |v| v.to_liquid }
    end
  end
end
