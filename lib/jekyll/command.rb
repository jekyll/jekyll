module Jekyll
  class Command
    def self.globs(source, destination)
      Dir.chdir(source) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
        dirs = dirs.map { |x| File.join(source, x) }
        dirs -= [destination]
        dirs = dirs.map { |x| "#{x}/**/*" }
        dirs += ['*']
      end
    end
  end
end
