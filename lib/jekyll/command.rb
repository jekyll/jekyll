module Jekyll
  class Command
    def self.globs(source, destination)
      Dir.chdir(source) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
        dirs -= [destination, File.realpath(destination), File.basename(destination)]
        dirs = dirs.map { |x| "#{x}/**/*" }
        dirs += ['*']
      end
    end
  end
end
