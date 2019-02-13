# frozen_string_literal: true

module Jekyll
  module Utils
    module Platforms
      extend self

      def jruby?
        RUBY_ENGINE == "jruby"
      end

      def mri?
        RUBY_ENGINE == "ruby"
      end

      def windows?
        @windows ||= vanilla_windows? || bash_on_windows?
      end

      # Not a Windows Subsystem for Linux (WSL)
      def vanilla_windows?
        @vanilla_windows ||= !!(rbconfig_host =~ %r!mswin|mingw|cygwin!) && proc_version.empty?
      end
      alias_method :really_windows?, :vanilla_windows?

      # Determine if Windows Subsystem for Linux (WSL)
      def bash_on_windows?
        @bash_on_windows ||= linux_os? && microsoft_proc_version?
      end

      def linux?
        @linux ||= linux_os? && !microsoft_proc_version?
      end

      def osx?
        @osx ||= !!(rbconfig_host =~ %r!darwin|mac os!)
      end

      def unix?
        @unix ||= !!(rbconfig_host =~ %r!solaris|bsd!)
      end

      private

      def proc_version
        @proc_version ||= \
          begin
            File.read("/proc/version").downcase
          rescue Errno::ENOENT, Errno::EACCES
            ""
          end
      end

      def rbconfig_host
        RbConfig::CONFIG["host_os"].downcase
      end

      def linux_os?
        rbconfig_host.include?("linux")
      end

      def microsoft_proc_version?
        proc_version.include?("microsoft")
      end
    end
  end
end
