require 'helper'
require 'jekyll/commands/draft'

class TestDraftCommand < Test::Unit::TestCase

  context 'when no flags are given' do
    setup do
      @name = 'A test post'
      @args = [@name]
      @drafts_dir = '_drafts'
      @path = File.join(@drafts_dir, 'a-test-post.markdown')
      stub(Jekyll).configuration { Jekyll::Configuration::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
      FileUtils.mkdir @drafts_dir
    end

    teardown do
      FileUtils.rm_r @drafts_dir
    end

    should 'create a new draft post' do
      assert !File.exist?(@path)
      capture_stdout { Jekyll::Commands::Draft.process(@args) }
      assert File.exist?(@path)
    end

    should 'write a success message' do
      output = capture_stdout { Jekyll::Commands::Draft.process(@args) }
      success_message = "New draft created at ./#{@path}.\n"
      assert_equal success_message, output
    end
  end

  context 'when the draft already exists' do
    setup do
      @name = 'An existing draft'
      @args = [@name]
      @drafts_dir = '_drafts'
      @path = File.join(@drafts_dir, 'an-existing-draft.markdown')
      stub(Jekyll).configuration { Jekyll::Configuration::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
      FileUtils.mkdir @drafts_dir
      FileUtils.touch @path
    end

    teardown do
      FileUtils.rm_r @drafts_dir
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        capture_stdout { Jekyll::Commands::Draft.process(@args) }
      end
      assert_equal "A draft already exists at ./#{@path}", exception.message
    end

    should 'overwrite the existing draft if --force is given' do
      capture_stdout { Jekyll::Commands::Draft.process(@args, { "force" => true  }) }
      assert File.readlines(@path).grep(/layout: post/).any?
    end
      
  end

  context 'when no args are given' do
    setup do
      @empty_args = []
    end

    should 'raise an ArgumentError' do
      exception = assert_raise ArgumentError do
        Jekyll::Commands::Draft.process(@empty_args)
      end
      assert_equal 'You must specify a name.', exception.message
    end
  end

end
