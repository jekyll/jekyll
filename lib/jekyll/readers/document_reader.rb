# frozen_string_literal: true

module Jekyll
  module DocumentReader
    # Read all the files in <source>/<dir>/<magic_dir> and create a new
    # Document object with each one insofar as it matches the regexp matcher.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_publishable(dir, magic_dir, matcher)
      read_content(dir, magic_dir, matcher).tap { |docs| docs.each(&:read) }
        .select do |doc|
          if doc.content.valid_encoding?
            site.publisher.publish?(doc).tap do |will_publish|
              if !will_publish && site.publisher.hidden_in_the_future?(doc)
                Jekyll.logger.debug "Skipping:", "#{doc.relative_path} has a future date"
              end
            end
          else
            Jekyll.logger.debug "Skipping:", "#{doc.relative_path} is not valid UTF-8"
            false
          end
        end
    end

    # Read all the content files from <source>/<dir>/magic_dir
    #   and return them with the type klass.
    #
    # dir - The String relative path of the directory to read.
    # magic_dir - The String relative directory to <dir>,
    #   looks for content here.
    # klass - The return type of the content.
    #
    # Returns klass type of content files
    def read_content(dir, magic_dir, matcher)
      label = label_from_dirname(magic_dir)
      site.reader.get_entries(dir, magic_dir).map do |entry|
        if label == "posts"
          next unless entry =~ matcher
        end
        path = site.in_source_dir(File.join(dir, magic_dir, entry))

        if Utils.has_yaml_header? path
          Document.new(path, {
            :site       => site,
            :collection => site.collections[label],
          })
        end
      end.reject(&:nil?)
    end

    private
    def label_from_dirname(magic_dir)
      return magic_dir unless magic_dir.start_with?("_")
      return "posts" if magic_dir =~ %r!\A_(draf|pos)ts\Z!
      magic_dir.sub("_", "")
    end
  end
end
