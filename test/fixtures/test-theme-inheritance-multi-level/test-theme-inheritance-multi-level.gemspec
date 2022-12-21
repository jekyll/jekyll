# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name     = "test-theme-inheritance-multi-level"
  s.version  = "0.1.0"
  s.licenses = ["MIT"]
  s.authors  = ["Jekyll"]
  s.summary  = "This is a theme used to test Jekyll's theme inheritance with multiple levels of inheritance"
  s.homepage = "https://github.com/jekyll/jekyll"
  s.files    = Dir["#{__dir__}/**/*"]

  s.metadata = {
    "parent_theme" => "test-theme-inheritance"
  }

  s.add_runtime_dependency("test-theme-inheritance", "~> 0.1")
end
