require File.expand_path("../../lib/jekyll.rb", __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  Jekyll.logger.set_log_level(:error)

  SOURCE_DIR   = File.expand_path('../test/source', File.dirname(__FILE__))
  DEST_DIR     = File.expand_path('../test/dest', File.dirname(__FILE__))
  FIXTURES_DIR = File.expand_path('../test/fixtures', File.dirname(__FILE__))

  def source_dir(*subpaths)
    File.join(SOURCE_DIR, *subpaths)
  end

  def dest_dir(*subpaths)
    File.join(DEST_DIR, *subpaths)
  end

  def fixture(*subpaths)
    File.join(FIXTURES_DIR, *subpaths)
  end

  def fixture_site
    Jekyll::Site.new(
      Jekyll.configuration(
        'source' => source_dir,
        'dest'   => dest_dir
      )
    )
  end
end
