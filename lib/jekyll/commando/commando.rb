$:.unshift File.dirname(__FILE__)

require 'command'
require 'program'

module Jekyll
  module Commando
    def self.program(name)
      program = Program.new(name)
      yield program
      program.go(ARGV)
    end
  end
end

# RUN

module Jek
  module Commands
    class Build
      def self.define(p)
        p.command(:build) do |c|
          c.syntax "jekyll build [options]"
          c.option '--safe', 'Safe mode?'
        end
      end
    end

    class Import
      class Typo
        def self.define(c)
          c.command(:typo) do |cc|
            c.option '--file FILE', 'File to import from'
#             c.option(:file) do |o|
#               o.name [ '-f', '--file']
#               o.description 'File to import from'
#               o.coerce String
#               o.valid? do |v|
#                 if v.length > 1
#                   true
#                 else
#                   "File name must be more than one character long."
#                 end
#               end
#             end
          end
        end
      end

      def self.define(p)
        p.command(:import) do |c|
          c.option '--safe', 'Safe mode?'

          Typo.define(c)
        end
      end
    end
  end
end

Jekyll::Commando.program(:jekyll) do |p|
  p.version "v0.1.0"
  p.description "I'm awesome"

  p.option '-s', '--source', 'Source of shit'

  Jek::Commands::Build.define(p)
  Jek::Commands::Import.define(p)
end