module Jekyll
  module Utils
    module Platforms extend self

      # Provides jruby? and mri? which respectively detect these two types of
      # tested Engines we support, in the future we might probably support the
      # other one that everyone used to talk about.

      { :jruby? => "jruby", :mri? => "ruby" }.each do |k, v|
        define_method k do
          ::RUBY_ENGINE == v
        end
      end

      # Provides windows?, linux?, osx?, unix? so that we can detect
      # platforms. This is mostly useful for `jekyll doctor` and for testing
      # where we kick off certain tests based on the platform.

      { :windows? => /mswin|mingw|cygwin/, :linux? => /linux/, \
          :osx? => /darwin|mac os/, :unix? => /solaris|bsd/ }.each do |k, v|

        define_method k do
          !!(
            RbConfig::CONFIG["host_os"] =~ v
          )
        end
      end
    end
  end
end
