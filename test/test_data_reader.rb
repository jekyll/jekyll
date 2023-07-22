# frozen_string_literal: true

require "helper"

class TestDataReader < JekyllUnitTest
  context "#sanitize_filename" do
    setup do
      @reader = DataReader.new(fixture_site)
    end

    should "remove evil characters" do
      assert_equal "helpwhathaveIdone", @reader.sanitize_filename(
        "help/what^&$^#*(!^%*!#haveId&&&&&&&&&one"
      )
    end
  end

  context "with no csv options set" do
    setup do
      @reader = DataReader.new(fixture_site)
      @parsed = [{ "id" => "1", "field_a" => "foo" }, { "id" => "2", "field_a" => "bar" }]
    end

    should "parse CSV normally" do
      assert_equal @parsed, @reader.read_data_file(File.expand_path("fixtures/sample.csv", __dir__))
    end

    should "parse TSV normally" do
      assert_equal @parsed, @reader.read_data_file(File.expand_path("fixtures/sample.tsv", __dir__))
    end
  end

  context "with csv options set" do
    setup do
      reader_config = {
        "csv_converters" => [:numeric],
        "headers"        => false,
      }

      @reader = DataReader.new(
        fixture_site(
          {
            "csv_reader" => reader_config,
            "tsv_reader" => reader_config,
          }
        )
      )

      @parsed = [%w(id field_a), [1, "foo"], [2, "bar"]]
    end

    should "parse CSV with options" do
      assert_equal @parsed, @reader.read_data_file(File.expand_path("fixtures/sample.csv", __dir__))
    end

    should "parse TSV with options" do
      assert_equal @parsed, @reader.read_data_file(File.expand_path("fixtures/sample.tsv", __dir__))
    end
  end
end
