require 'test/unit'

# for some reason these tests fail when run via TextMate
# but succeed when run on the command line.

tests = Dir["#{File.dirname(__FILE__)}/test_*.rb"]
tests.each do |file|
  require file
end