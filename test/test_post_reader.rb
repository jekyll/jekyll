# frozen_string_literal: true

require "helper"

class TestPostReader < JekyllUnitTest
  context "#read_publishable" do
    setup do
      @site = Site.new(site_configuration)
      @post_reader = PostReader.new(@site)
      @dir = ""
      @magic_dir = "_posts"
      @matcher = Document::DATE_FILENAME_MATCHER
    end

    should "skip unprocessable documents" do
      all_file_names = all_documents.collect(&:basename)
      processed_file_names = processed_documents.collect(&:basename)

      actual_skipped_file_names = all_file_names - processed_file_names

      expected_skipped_file_names = [
        "2008-02-02-not-published.markdown",
        "2008-02-03-wrong-extension.yml",
      ]

      skipped_file_names_difference = expected_skipped_file_names - actual_skipped_file_names

      assert expected_skipped_file_names.count.positive?,
             "There should be at least one document expected to be skipped"
      assert_empty skipped_file_names_difference,
                   "The skipped documents (expected/actual) should be congruent (= empty array)"
    end
  end

  def all_documents
    @post_reader.read_content(@dir, @magic_dir, @matcher)
  end

  def processed_documents
    @post_reader.read_publishable(@dir, @magic_dir, @matcher)
  end
end
