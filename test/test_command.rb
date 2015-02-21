require 'helper'

class TestCommand < JekyllUnitTest
  context "when calling .add_build_options" do
    should "add common options" do
      cmd = Object.new
      mock(cmd).option.with_any_args.at_least(1)
      Command.add_build_options(cmd)
    end
  end
  context "when calling .process_site" do
    context "when fatal error occurs" do
      should "exit with non-zero error code" do
        site = Object.new
        stub(site).process { raise Jekyll::Errors::FatalException }
        error = assert_raises(SystemExit) { Command.process_site(site) }
        refute_equal 0, error.status
      end
    end
  end
end
