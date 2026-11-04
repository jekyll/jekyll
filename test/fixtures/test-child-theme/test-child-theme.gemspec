# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name     = "test-child-theme"
  s.version  = "0.1.0"
  s.licenses = ["MIT"]
  s.summary  = "Child theme fixture for Jekyll"
  s.authors  = ["Jekyll"]
  s.required_ruby_version = ">= 2.7"
  s.files = Dir["{_layouts,_includes,_sass,_data,assets}/**/*", "_config.yml"]
  s.metadata["jekyll:parent_theme"] = "test-parent-theme"
  s.add_runtime_dependency "test-parent-theme", "~> 0.1"
end
