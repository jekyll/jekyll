require 'helper'
require 'date'
require 'jekyll/commands/publish'

class TestPublishCommand < Test::Unit::TestCase

  context 'when no flags are given' do
    setup do
      @name = 'a-test-post.markdown'
      @args = [@name]
      @drafts_dir = '_drafts'
      @posts_dir = '_posts'
      @draft_path = File.join(@drafts_dir, 'a-test-post.markdown')
      @post_path = File.join(@posts_dir, "#{Time.now.strftime('%Y-%m-%d')}-#{@name}")
      FileUtils.mkdir @drafts_dir
      FileUtils.mkdir @posts_dir
      FileUtils.touch @draft_path
    end

    teardown do
      FileUtils.rm_r @drafts_dir
      FileUtils.rm_r @posts_dir
    end

    should 'publish a draft post' do
      assert !File.exist?(@post_path), 'Post already exists'
      assert File.exist?(@draft_path), 'Draft does not exist'
      capture_stdout { Jekyll::Commands::Publish.process(@args) }
      assert File.exist?(@post_path), 'Post does not exist'
    end

    should 'write a success message' do
      output = capture_stdout { Jekyll::Commands::Publish.process(@args) }
      success_message = "Draft #{@name} was published to ./#{@post_path}\n"
      assert_equal success_message, output
    end
  end

  context 'when no args are given' do
    setup do
      @empty_args = []
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        Jekyll::Commands::Publish.process(@empty_args)
      end
      assert_equal 'You must specify a name.', exception.message
    end
  end

end
