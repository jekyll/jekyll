require 'helper'

class TestDocument < Test::Unit::TestCase

  context "a document in a collection" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["methods"],
        "source"      => source_dir,
        "destination" => dest_dir
      }))
      @site.process
      @document = @site.collections["methods"].docs.first
    end

    should "know its relative path" do
      assert_equal "_methods/configuration.md", @document.relative_path
    end

    should "knows its extname" do
      assert_equal ".md", @document.extname
    end

    should "know its basename" do
      assert_equal "configuration.md", @document.basename
    end

    should "allow the suffix to be specified for the basename" do
      assert_equal "configuration", @document.basename(".*")
    end

    should "know whether its a yaml file" do
      assert_equal false, @document.yaml_file?
    end

    should "know its data" do
      assert_equal({
        "title" => "Jekyll.configuration",
        "whatever" => "foo.bar"
      }, @document.data)
    end

  end

  context "a document as part of a collection with frontmatter defaults" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["methods"],
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope"=> {"path"=>"", "type"=>"methods"},
          "values"=> {
            "nested"=> {
              "test1"=>"default1",
              "test2"=>"default1"
            }
          }
        }]
      }))
      @site.process
      @document = @site.collections["methods"].docs.first
    end

    should "know the frontmatter defaults" do
      assert_equal({
        "title"=>"Jekyll.configuration",
        "nested"=> { 
          "test1"=>"default1", 
          "test2"=>"default1"},
        "whatever"=>"foo.bar"
      }, @document.data)
    end

    should "overwrite a default value in the document frontmatter" do

    end

    should "overwrite a nested default value in the document frontmatter" do

    end
  end

  context " a document part of a rendered collection" do
  end

end
