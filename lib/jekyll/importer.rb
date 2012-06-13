require 'fileutils'

module Jekyll
  class Importer
    def self.write_files(files)
      files.keys.each { |key| FileUtils.mkdir_p "_#{key}" }

      files.each do |type, specs|
        specs.each do |spec|
          File.open("_#{type}/#{spec[:name]}", "w") do |f|
            f.puts "---"
            spec[:header].each { |key, value| f.puts "#{key}: #{value}" }
            f.puts "---"
            f.puts
            f.puts spec[:body]
          end
        end
      end

      files
    end
  end
end
