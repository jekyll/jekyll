module Jekyll
  class Document

    private #==================================================================

    def has_yaml_header?(file)
      "---" == File.open(file) { |fd| fd.read(3) }
    end

  end
end
