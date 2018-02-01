# frozen_string_literal: true

class Jekyll::ThemeBuilder
  SCAFFOLD_DIRECTORIES = %w(
    assets _layouts _includes _sass
  ).freeze

  attr_reader :name, :path, :code_of_conduct

  def initialize(theme_name, opts)
    @name = theme_name.to_s.tr(" ", "_").squeeze("_")
    @path = Pathname.new(File.expand_path(name, Dir.pwd))
    @code_of_conduct = !!opts["code_of_conduct"]
  end

  def create!
    create_directories
    create_starter_files
    create_gemspec
    create_accessories
    initialize_git_repo
  end

  def user_name
    @user_name ||= `git config user.name`.chomp
  end

  def user_email
    @user_email ||= `git config user.email`.chomp
  end

  private

  def root
    @root ||= Pathname.new(File.expand_path("../", __dir__))
  end

  def template_file(filename)
    [
      root.join("theme_template", "#{filename}.erb"),
      root.join("theme_template", filename.to_s),
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
    accessories = %w(README.md LICENSE.txt)
    accessories << "CODE_OF_CONDUCT.md" if code_of_conduct
    accessories.each do |filename|
      write_file(filename, template(filename))
    end
  end

  def initialize_git_repo
    Jekyll.logger.info "initialize", path.join(".git").to_s
    Dir.chdir(path.to_s) { `git init` }
    write_file(".gitignore", template("gitignore"))
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
