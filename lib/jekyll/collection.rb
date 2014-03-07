module Jekyll
  class Collection
    attr_reader :name, :site
    attr_accessor :relative_directory

    def initialize(site, collection_name)
      @site = site
      @name = collection_name
      @relative_directory = "_#{collection_name}"
    end

    def documents
      @documents ||= read_documents
    end

    def directory
      Jekyll.sanitized_path(site.source, relative_directory)
    end

    def read_documents
      entries = []
      within(directory) do
        Dir['**/*.*'].each do |filename|
          if klass_for_collection.valid_filename?(filename)
            entries << klass_for_collection.new(site, directory, filename)
          else
            Jekyll.logger.debug("#{directory}:", "'#{filename}' is an invalid filename. Skipping.")
          end
        end
      end
      entries
    end

    # Public: Execute a block inside a given directory
    #
    # dir   - the directory to change to
    # block - the block to call
    #
    # Returns the return value of the block being called
    def within(dir, &block)
      return unless File.exists?(dir)
      Dir.chdir(dir) { block.call }
    end

    # Public: Fetch the class for the collection documents
    #
    # Returns the class that should be instantiated for each item in the
    def klass_for_collection
      class_name = name.split("_").map{ |n| n.capitalize.sub(/s\z/, "") }.join("")
      if Jekyll.const_defined?(:"#{class_name}")
        Jekyll.const_get(class_name)
      else
        Jekyll::Document
      end
    end

    # Public: Writes each of the documents to the destination directory
    #
    # Returns a list of the filepaths written to the destination
    def write_output
      within(site.destination) do
        documents.each do |document|
          File.open(document.destination, 'wb') { File.write(document.output) }
        end
      end
    end

  end
end
