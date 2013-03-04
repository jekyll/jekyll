require 'optparse'

module Jekyll
  module Commando
    class Program < Command
      attr_reader :version
      attr_reader :description
      attr_reader :optparse
      attr_reader :config

      def initialize(name)
        @config = { }
        super(name)
      end

      def version(version)
        @version = version
      end

      def description(description)
        @description = description
      end

      def go(argv)
        p argv
        puts
        p self

        @optparse = OptionParser.new do |opts|
          super(argv, opts, @config)
        end

        @optparse.parse!(argv)

        p @config
      end
    end
  end
end