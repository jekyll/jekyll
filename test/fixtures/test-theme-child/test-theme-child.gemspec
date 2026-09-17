# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = "test-theme-child"
  spec.version     = "0.1.0"
  spec.licenses    = ["MIT"]
  spec.summary     = "A child theme used to test Jekyll theme inheritance"
  spec.authors     = ["Jekyll"]
  spec.files       = Dir["**/*"].reject { |path| File.directory?(path) }
  spec.homepage    = "https://github.com/jekyll/jekyll"
  spec.metadata    = { "parent_theme" => "test-theme" }
  spec.required_ruby_version = ">= 2.7.0"

  spec.add_runtime_dependency "test-theme", "~> 0.1"
end
