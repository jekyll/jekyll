require 'helper'

class TestCommand < Test::Unit::TestCase
  context "when calling .ignore_paths" do
    context "when source is absolute" do
      setup { @source = source_dir }
      should "return an array with regex for destination" do
        absolute = source_dir('dest')
        relative = Pathname.new(source_dir('dest')).relative_path_from(Pathname.new('.').expand_path).to_s
        [absolute, relative].each do |dest|
          config = build_configs("source" => @source, "destination" => dest)
          assert Command.ignore_paths(config).include?(/dest/), "failed with destination: #{dest}"
        end
      end
    end
    context "when source is relative" do
      setup { @source = Pathname.new(source_dir).relative_path_from(Pathname.new('.').expand_path).to_s }
      should "return an array with regex for destination" do
        absolute = source_dir('dest')
        relative = Pathname.new(source_dir('dest')).relative_path_from(Pathname.new('.').expand_path).to_s
        [absolute, relative].each do |dest|
          config = build_configs("source" => @source, "destination" => dest)
          assert Command.ignore_paths(config).include?(/dest/), "failed with destination: #{dest}"
        end
      end
    end
    context "multiple config files" do
      should "return an array with regex for config files" do
        config = build_configs("config"=> ["_config.yaml", "_config2.yml"])
        ignore_paths = Command.ignore_paths(config)
        assert ignore_paths.include?(/_config\.yaml/), 'did not include _config.yaml'
        assert ignore_paths.include?(/_config2\.yml/), 'did not include _config2.yml'
      end
    end
  end
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
        stub(site).process { raise Jekyll::FatalException }
        error = assert_raise(SystemExit) { Command.process_site(site) }
        assert_not_equal 0, error.status
      end
    end
  end
end
