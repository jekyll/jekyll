module Jekyll

  class MigrateCommand < Command
    MIGRATORS = {
      :csv => 'CSV',
      :drupal => 'Drupal',
      :enki => 'Enki',
      :mephisto => 'Mephisto',
      :mt => 'MT',
      :posterous => 'Posterous',
      :textpattern => 'TextPattern',
      :tumblr => 'Tumblr',
      :typo => 'Typo',
      :wordpressdotcom => 'WordpressDotCom',
      :wordpress => 'WordPress'
    }

    def self.process(migrator, options)
      abort 'missing argument. Please specify a migrator' if migrator.nil?
      migrator = migrator.downcase

      cmd_options = []
      [ :file, :dbname, :user, :pass, :host, :site ].each do |p|
        cmd_options << "\"#{options[p]}\"" unless options[p].nil?
      end


      if MIGRATORS.keys.include?(migrator)
        app_root = File.expand_path(
          File.join(File.dirname(__FILE__), '..', '..', '..')
        )

        require "#{app_root}/lib/jekyll/migrators/#{migrator}"

        if Jekyll.const_defiend?(MIGRATORS[migrator.to_sym])
          puts 'Importing...'
          migrator_class = Jekyll.const_get(MIGRATORS[migrator.to_sym])
          migrator_class.process(*cmd_options)
          exit 0
        end
      end

      abort 'invalid migrator. Please specify a valid migrator'
    end
  end

end
