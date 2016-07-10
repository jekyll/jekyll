class Jekyll::ThemeBuilder
  SCAFFOLD_DIRECTORIES = %w(
    _layouts _includes _sass
  ).freeze

  attr_reader :name, :path

  def initialize(theme_name)
    @name = theme_name.to_s.tr(" ", "_").gsub(%r!_+!, "_")
    @path = Pathname.new(File.expand_path(name, Dir.pwd))
  end

  def create!
    create_directories
    create_starter_files
    create_gemspec
    create_accessories
    create_example_site
    initialize_git_repo
  end

  private

  def root
    @root ||= Pathname.new(File.expand_path("../", __dir__))
  end

  def template_file(filename)
    [
      root.join("theme_template", "#{filename}.erb"),
      root.join("theme_template", filename.to_s)
    ].find(&:exist?)
  end

  def template(filename)
    erb.render(template_file(filename).read)
  end

  def erb
    @erb ||= ERBRenderer.new(self)
  end

  def mkdir_p(directories)
    Array(directories).each do |directory|
      full_path = path.join(directory)
      Jekyll.logger.info "create", full_path.to_s
      FileUtils.mkdir_p(full_path)
    end
  end

  def write_file(filename, contents)
    full_path = path.join(filename)
    Jekyll.logger.info "create", full_path.to_s
    File.write(full_path, contents)
  end

  def create_directories
    mkdir_p(SCAFFOLD_DIRECTORIES)
    mkdir_p(%w(example example/_posts))
  end

  def create_starter_files
    %w(page post default).each do |layout|
      write_file("_layouts/#{layout}.html", template("_layouts/#{layout}.html"))
    end
  end

  def create_gemspec
    write_file("Gemfile", template("Gemfile"))
    write_file("#{name}.gemspec", template("theme.gemspec"))
  end

  def create_accessories
    %w(README.md Rakefile CODE_OF_CONDUCT.md LICENSE.txt).each do |filename|
      write_file(filename, template(filename))
    end
  end

  def create_example_site
    %w(example/_config.yml example/index.html example/style.scss).each do |filename|
      write_file(filename, template(filename))
    end
    write_file(
      "example/_posts/#{Time.now.strftime("%Y-%m-%d")}-my-example-post.md",
      template("example/_post.md")
    )
  end

  def initialize_git_repo
    Jekyll.logger.info "initialize", path.join(".git").to_s
    Dir.chdir(path.to_s) { `git init` }
    write_file(".gitignore", template("gitignore"))
  end

  def user_name
    @user_name ||= `git config user.name`.chomp
  end

  def user_email
    @user_email ||= `git config user.email`.chomp
  end

  class ERBRenderer
    extend Forwardable

    def_delegator :@theme_builder, :name, :theme_name
    def_delegator :@theme_builder, :user_name, :user_name
    def_delegator :@theme_builder, :user_email, :user_email

    def initialize(theme_builder)
      @theme_builder = theme_builder
    end

    def jekyll_version_with_minor
      Jekyll::VERSION.split(".").take(2).join(".")
    end

    def theme_directories
      SCAFFOLD_DIRECTORIES
    end

    def render(contents)
      ERB.new(contents).result binding
    end
  end
end
