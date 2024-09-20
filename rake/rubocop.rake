# frozen_string_literal: true

namespace :rubocop do
  desc "Format existing `.rubocop.yml` to improve readability"
  task :format_config do
    require_relative "./task_utils/rubocop_config_formatter"

    config_file = File.expand_path("../.rubocop.yml", __dir__)
    if File.exist?(config_file)
      print " Configuration File: "
      puts config_file
      puts "formating...".rjust(20)
    else
      puts "#{config_file} not found! Exiting."
      exit!
    end

    Jekyll::TaskUtils::RuboCopConfigFormatter.new(config_file).format!
    puts "done!".rjust(26)
  end
end
