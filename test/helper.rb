require 'rubygems'
gem 'RedCloth', '>= 4.2.1'

require File.join(File.dirname(__FILE__), *%w[.. lib jekyll])

require 'RedCloth'
require 'rdiscount'
require 'kramdown'

require 'shoulda'
require 'rr'

require 'test/unit'
require 'test/unit/ui/console/testrunner'
class Test::Unit::UI::Console::TestRunner; def guess_color_availability; true; end; end

include Jekyll

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def dest_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'dest', *subdirs)
  end

  def source_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
  end
end
