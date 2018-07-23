# frozen_string_literal: true

require "helper"

class TestCommand < JekyllUnitTest
  context "when calling .add_build_options" do
    should "add common options" do
      cmd = Object.new
      mocks_expect(cmd).to receive(:option).at_least(:once)
      Command.add_build_options(cmd)
    end
  end

  context "when calling .process_site" do
    context "when fatal error occurs" do
      should "exit with non-zero error code" do
        site = Object.new
        def site.process
          raise Jekyll::Errors::FatalException
        end
        error = assert_raises(SystemExit) { Command.process_site(site) }
        refute_equal 0, error.status
      end
    end
  end
end
