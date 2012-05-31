require 'helper'
require 'jekyll/migrators/wordpressdotcom'

class TestWordpressDotCom < Test::Unit::TestCase
  context 'migrating from wordpress.com' do
    setup do
      @wordpressxml = File.join(fixtures_dir, 'wordpress.xml')
    end

    should 'import post with a slash in the title from wordpress.xml' do
      stub(FileUtils).mkdir_p(anything)
      stub(File).open(anything, anything)
      imported = Jekyll::WordpressDotCom.process(@wordpressxml)
      assert_equal 1, imported['page']
      assert_equal 2, imported['post']
    end
  end
end
