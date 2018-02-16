# frozen_string_literal: true

#############################################################################
#
# Packaging tasks for jekyll-docs
#
#############################################################################

namespace :docs do
  desc "Release #{docs_name} v#{version}"
  task :release => :build do
    unless `git branch` =~ %r!^\* master$!
      puts "You must be on the master branch to release!"
      exit!
    end
    sh "gem push pkg/#{docs_name}-#{version}.gem"
  end

  desc "Build #{docs_name} v#{version} into pkg/"
  task :build do
    mkdir_p "pkg"
    sh "gem build #{docs_name}.gemspec"
    sh "mv #{docs_name}-#{version}.gem pkg"
  end
end
