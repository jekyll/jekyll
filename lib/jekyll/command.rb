module Jekyll

  class Command
    def self.globs(source)
      Dir.chdir(source) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
        dirs -= ['_site']
        dirs = dirs.map { |x| "#{x}/**/*" }
        dirs += ['*']
      end
    end
  end

end
