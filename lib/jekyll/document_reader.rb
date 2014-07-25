module Jekyll
  class DocumentReader
    attr_reader :doc

    def initialize(doc)
      @doc = doc
    end

    def read
      begin
        doc.content = File.read(doc.full_path, { :encoding => "utf-8" })
        if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          doc.content = $POSTMATCH
          front_matter = SafeYAML.load($1)
          unless front_matter.nil?
            doc.data ||= Hash.new
            doc.data = Utils.deep_merge_hashes(doc.data, front_matter)
          end
        end
      rescue SyntaxError => e
        puts "YAML Exception reading #{doc.path}: #{e.message}"
      rescue Exception => e
        puts "Error reading file #{doc.path}: #{e.message}"
      end
      doc
    end

  end
end