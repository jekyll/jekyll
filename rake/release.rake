# frozen_string_literal: true

#############################################################################
#
# Packaging tasks
#
#############################################################################

desc "Release #{name} v#{version}"
task :release => :build do
  current_branch = `git branch`.to_s.strip.match(%r!^\* (.+)$!)[1]
  unless current_branch == "master" || current_branch.end_with?("-stable")
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -m 'Release :gem: #{version}'"
  sh "git tag v#{version}"
  sh "git push origin #{current_branch}"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Build #{name} v#{version} into pkg/"
task :build do
  mkdir_p "pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end
