module Jekyll

  class ADummyConverter < Converter

    priority :high

    def matches(ext)
      false
    end

  end

end
