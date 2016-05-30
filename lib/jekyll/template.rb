module Jekyll
  class Template

    attr_accessor :type, :path, :options, :date, :external_url, :title

    def initialize(type, opts)
      raise ArgumentError.new('You must specify either a path or a title.') if !opts[:title] && !opts[:path]

      self.type    = type.downcase
      self.options = opts
      self.layout  = options[:layout] || "#{self.type}"
      self.date    = Time.now if self.type = "post"
      self.title   = determine_title
      self.path    = determine_path
    end

    def content
      frontmatter + "\n---\n\n"
    end

    def write
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "wb") do |file|
        file.puts(content)
      end
    end

    private

    def determine_path
      if options[:path]
        specified_path = options[:path]
        if File.extname(specified_path).empty?
          specified_path = File.join(specified_path, "index.#{options[:ext]}")
        end
        specified_path
      else
        case type
        when "drafts"
          "_drafts/#{slug}.#{options[:ext]}"
        when "post"
          "_posts/#{date.strftime('%Y-%m-%d')}-#{slug}.#{options[:ext]}"
        when "page"
          "#{slug}.#{options[:ext]}"
        end
      end
    end

    def determine_title
      if options[:title]
        options[:title]
      else
        titleize(path)
      end
    end

    def slug
      title.gsub(" ", "-").gsub(/[^\w-]/, "").downcase
    end

    def titleize(something)
      something.gsub(File.extname(something), '').split("-").map(&:capitalize).join(" ")
    end

    def frontmatter
      base = {
        "layout" => layout,
        "title" => title
      }
      YAML.dump(base.merge(date_frontmatter).merge(external_url_frontmatter))
    end

    def date_frontmatter
      if date
        { "date" => date.xmlschema }
      else
        {}
      end
    end

    def external_url_frontmatter
      if external_url
        { "external-url" => external_url }
      else
        {}
      end
    end

  end
end
