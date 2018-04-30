# frozen_string_literal: true

Dir[File.join(File.expand_path("jekyll", __dir__), "*.rb")].each do |ruby_file|
  require ruby_file
end
