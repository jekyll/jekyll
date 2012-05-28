module Jekyll

  class ZDummyConverter < Converter

    priority :highest

    def matches(ext)
      false
    end

  end

end
