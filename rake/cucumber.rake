begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) { |t| t.profile = "travis" }
  Cucumber::Rake::Task.new(:"features:html", "Run Cucumber features w/ HTML output") do |t|
    t.profile = "html_report"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin.'
  end
end
