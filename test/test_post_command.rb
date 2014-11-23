require 'helper'
require 'jekyll/commands/post'

class TestPostCommand < Test::Unit::TestCase


  context 'when args given' do
    setup do
      @path = '_posts'
      @args = ['This Is A Test Post']
      @full_path = File.expand_path(@path, Dir.pwd)
    end

    teardown do
      FileUtils.rm_r @full_path
    end

    should 'create a new post in the _posts directory' do 
      Jekyll::Commands::Post.process(@args)
      assert File.exist?(Jekyll::Commands::Post.initialize_post_name(@args))
    end
  end


  context 'when no args given' do 
    setup do 
      @empty_args = []
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        Jekyll::Commands::Post.process(@empty_args)
      end
      assert_equal 'You must specify a post title.', exception.message
    end
  end

end