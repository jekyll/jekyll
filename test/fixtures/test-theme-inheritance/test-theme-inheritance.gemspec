# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "test-theme-inheritance"
  s.version     = "0.1.0"
  s.licenses    = ["MIT"]
  s.summary     = "This is a theme used to test Jekyll's theme inheritance"
  s.authors     = ["Jekyll"]
  s.files       = ["lib/example.rb"]
  s.homepage    = "https://github.com/jekyll/jekyll"

  s.metadata    = {
    "parent_theme" => "test-theme"
  }
  s.add_runtime_dependency("test-theme", "~> 0.1")
end
