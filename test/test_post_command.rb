require 'helper'
require 'jekyll/commands/post'

class TestPostCommand < Test::Unit::TestCase

  context 'when no flags are given' do
    setup do
      @name = 'A test post'
      @args = [@name]
      @posts_dir = '_posts'
      @path = File.join(@posts_dir, "#{Time.now.strftime('%Y-%m-%d')}-a-test-post.markdown")
      FileUtils.mkdir @posts_dir
    end

    teardown do
      FileUtils.rm_r @posts_dir
    end

    should 'create a new post' do
      assert !File.exist?(@path)
      capture_stdout { Jekyll::Commands::Post.process(@args) }
      assert File.exist?(@path)
    end

    should 'write a success message' do
      output = capture_stdout { Jekyll::Commands::Post.process(@args) }
      success_message = "New post created at ./#{@path}.\n"
      assert_equal success_message, output
    end
  end

  context 'when the post already exists' do
    setup do
      @name = 'An existing post'
      @args = [@name]
      @posts_dir = '_posts'
      @path = File.join(@posts_dir, "#{Time.now.strftime('%Y-%m-%d')}-an-existing-post.markdown")
      FileUtils.mkdir @posts_dir
      FileUtils.touch @path
    end

    teardown do
      FileUtils.rm_r @posts_dir
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        capture_stdout { Jekyll::Commands::Post.process(@args) }
      end
      assert_equal "A post already exists at ./#{@path}", exception.message
    end

    should 'overwrite the existing post if --force is given' do
      capture_stdout { Jekyll::Commands::Post.process(@args, { "force" => true  }) }
      assert File.readlines(@path).grep(/layout: post/).any?
    end
      
  end

  context 'when no args are given' do
    setup do
      @empty_args = []
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        Jekyll::Commands::Post.process(@empty_args)
      end
      assert_equal 'You must specify a name.', exception.message
    end
  end

end
