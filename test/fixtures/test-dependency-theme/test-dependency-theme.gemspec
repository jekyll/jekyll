# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = "test-dependency-theme"
  s.version       = "0.1.0"
  s.licenses      = ["MIT"]
  s.summary       = "This is another theme used to test Jekyll"
  s.authors       = ["Jekyll"]
  s.files         = ["lib/example.rb"]
  s.homepage      = "https://github.com/jekyll/jekyll"

  s.add_runtime_dependency "jekyll_test_plugin"
end
