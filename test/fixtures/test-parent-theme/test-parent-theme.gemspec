# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name     = "test-parent-theme"
  s.version  = "0.1.0"
  s.licenses = ["MIT"]
  s.summary  = "Parent theme fixture for Jekyll"
  s.authors  = ["Jekyll"]
  s.required_ruby_version = ">= 2.7"
  s.files = Dir["{_layouts,_includes,_sass,_data,assets}/**/*", "_config.yml"]
end
