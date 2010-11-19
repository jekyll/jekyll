##
# Wrapper for the Pygments command line tool, pygmentize.
#
# Pygments: http://pygments.org/
#
# Assumes pygmentize is in the path.  If not, set its location
# with Albino.bin = '/path/to/pygmentize'
#
# Use like so:
#
#   @syntaxer = Albino.new('/some/file.rb', :ruby)
#   puts @syntaxer.colorize
#
# This'll print out an HTMLized, Ruby-highlighted version
# of '/some/file.rb'.
#
# To use another formatter, pass it as the third argument:
#
#   @syntaxer = Albino.new('/some/file.rb', :ruby, :bbcode)
#   puts @syntaxer.colorize
#
# You can also use the #colorize class method:
#
#   puts Albino.colorize('/some/file.rb', :ruby)
#
# Another also: you get a #to_s, for somewhat nicer use in Rails views.
#
#   ... helper file ...
#   def highlight(text)
#     Albino.new(text, :ruby)
#   end
#
#   ... view file ...
#   <%= highlight text %>
#
# The default lexer is 'text'.  You need to specify a lexer yourself;
# because we are using STDIN there is no auto-detect.
#
# To see all lexers and formatters available, run `pygmentize -L`.
#
# Chris Wanstrath // chris@ozmm.org
#         GitHub // http://github.com
#

class Albino
  @@bin = Rails.development? ? 'pygmentize' : '/usr/bin/pygmentize' rescue 'pygmentize'

  def self.bin=(path)
    @@bin = path
  end

  def self.colorize(*args)
    new(*args).colorize
  end

  def initialize(target, lexer = :text, format = :html)
    @target  = target
    @options = { :l => lexer, :f => format, :O => 'encoding=utf-8' }
  end

  def execute(command)
    output = ''
    IO.popen(command, mode='r+') do |p|
      p.write @target
      p.close_write
      output = p.read.strip
    end
    output
  end

  def colorize(options = {})
    html = execute(@@bin + convert_options(options))
    # Work around an RDiscount bug: http://gist.github.com/97682
    html.to_s.sub(%r{</pre></div>\Z}, "</pre>\n</div>")
  end
  alias_method :to_s, :colorize

  def convert_options(options = {})
    @options.merge(options).inject('') do |string, (flag, value)|
      string + " -#{flag} #{value}"
    end
  end
end

if $0 == __FILE__
  require 'rubygems'
  require 'test/spec'
  require 'mocha'
  begin require 'redgreen'; rescue LoadError; end

  context "Albino" do
    setup do
      @syntaxer = Albino.new(__FILE__, :ruby)
    end

    specify "defaults to text" do
      syntaxer = Albino.new(__FILE__)
      syntaxer.expects(:execute).with('pygmentize -f html -l text').returns(true)
      syntaxer.colorize
    end

    specify "accepts options" do
      @syntaxer.expects(:execute).with('pygmentize -f html -l ruby').returns(true)
      @syntaxer.colorize
    end

    specify "works with strings" do
      syntaxer = Albino.new('class New; end', :ruby)
      assert_match %r(highlight), syntaxer.colorize
    end

    specify "aliases to_s" do
      assert_equal @syntaxer.colorize, @syntaxer.to_s
    end

    specify "class method colorize" do
      assert_equal @syntaxer.colorize, Albino.colorize(__FILE__, :ruby)
    end
  end
end
