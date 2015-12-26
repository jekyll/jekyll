#############################################################################
#
# Packaging tasks for jekyll-docs
#
#############################################################################

namespace :docs do
  desc "Release #{docs_name} v#{version}"
  task :release => :build do
    unless `git branch` =~ /^\* master$/
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

task :analysis do
  require "jekyll/utils/ansi"
  require "open3"

  cmd = [
    "docker", "run", "--rm", "--env=CODE_PATH=#{Dir.pwd}", \
    "--volume='#{Dir.pwd}:/code'", "--volume=/var/run/docker.sock:/var/run/docker.sock", \
    "--volume=/tmp/cc:/tmp/cc", "-i", "codeclimate/codeclimate", "analyze"
  ]

  ansi = Jekyll::Utils::Ansi
  file = File.open(".analysis", "w+")
  Open3.popen3(cmd.shelljoin) do |_, out, err, _|
    while data = out.gets
      file.write data
      if data =~ /\A==/
        $stdout.print ansi.yellow(data)

      elsif data !~ %r!\A[0-9\-]+!
        $stdout.puts data

      else
        h, d = data.split(":", 2)
        $stdout.print ansi.cyan(h)
        $stdout.print ":", d
      end
    end

    while data = err.gets
      file.write data
      $stderr.print ansi.red(data)
    end
  end

  file.close
end
