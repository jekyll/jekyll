module Jekyll
  module Utils
    module Platforms
      extend self

      # Provides jruby? and mri? which respectively detect these two types of
      # tested Engines we support, in the future we might probably support the
      # other one that everyone used to talk about.

      { :jruby? => "jruby", :mri? => "ruby" }.each do |k, v|
        define_method k do
          ::RUBY_ENGINE == v
        end
      end

      # --
      # Allows you to detect "real" Windows, or what we would consider
      # "real" Windows.  That is, that we can pass the basic test and the
      # /proc/version returns nothing to us.
      # --

      def vanilla_windows?
        RbConfig::CONFIG["host_os"] =~ %r!mswin|mingw|cygwin!i && \
          !proc_version
      end

      # --
      # XXX: Remove in 4.0
      # --

      alias_method :really_windows?, \
        :vanilla_windows?

      #

      def bash_on_windows?
        RbConfig::CONFIG["host_os"] =~ %r!linux! && \
          proc_version =~ %r!microsoft!i
      end

      #

      def windows?
        vanilla_windows? || bash_on_windows?
      end

      #

      def linux?
        RbConfig::CONFIG["host_os"] =~ %r!linux! && \
          proc_version !~ %r!microsoft!i
      end

      # Provides windows?, linux?, osx?, unix? so that we can detect
      # platforms. This is mostly useful for `jekyll doctor` and for testing
      # where we kick off certain tests based on the platform.

      { :osx? => %r!darwin|mac os!, :unix? => %r!solaris|bsd! }.each do |k, v|
        define_method k do
          !!(
            RbConfig::CONFIG["host_os"] =~ v
          )
        end
      end

      #

      private
      def proc_version
        @cached_proc_version ||= begin
          Pathutil.new(
            "/proc/version"
          ).read
        rescue Errno::ENOENT
          nil
        end
      end
    end
  end
end
