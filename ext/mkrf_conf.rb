require 'rubygems/dependency_installer.rb'

installer = Gem::DependencyInstaller.new

begin
  if RUBY_VERSION < "1.9"
    installer.install "md2man", "~> 2.0.0"
  else

  end

  rescue
    exit(1)
end

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close
