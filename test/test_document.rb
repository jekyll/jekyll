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

    should "output the collection name in the #to_liquid method" do
      assert_equal @document.to_liquid['collection'], "methods"
    end

  end

  context "a document as part of a collection with frontmatter defaults" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["slides"],
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope"=> {"path"=>"", "type"=>"slides"},
          "values"=> {
            "nested"=> {
              "key"=>"myval",
            }
          }
        }]
      }))
      @site.process
      @document = @site.collections["slides"].docs.first
    end

    should "know the frontmatter defaults" do
      assert_equal({
        "title"=>"Example slide",
        "layout"=>"slide",
        "nested"=> { 
          "key"=>"myval"
        }
      }, @document.data)
    end
  end

  context "a document as part of a collection with overriden default values" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["slides"],
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope"=> {"path"=>"", "type"=>"slides"},
          "values"=> {
            "nested"=> {
              "test1"=>"default1",
              "test2"=>"default1"
            }
          }
        }]
      }))
      @site.process
      @document = @site.collections["slides"].docs[1]
    end

    should "override default values in the document frontmatter" do
      assert_equal({
        "title"=>"Override title",
        "layout"=>"slide",
        "nested"=> { 
          "test1"=>"override1",
          "test2"=>"override2"
        }
      }, @document.data)
    end
  end

  context "a document as part of a collection with valid path" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["slides"],
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope"=> {"path"=>"slides", "type"=>"slides"},
          "values"=> {
            "nested"=> {
              "key"=>"value123",
            }
          }
        }]
      }))
      @site.process
      @document = @site.collections["slides"].docs.first
    end

    should "know the frontmatter defaults" do
      assert_equal({
        "title"=>"Example slide",
        "layout"=>"slide",
        "nested"=> { 
          "key"=>"value123"
        }
      }, @document.data)
    end
  end

  context "a document as part of a collection with invalid path" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["slides"],
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope"=> {"path"=>"somepath", "type"=>"slides"},
          "values"=> {
            "nested"=> {
              "key"=>"myval",
            }
          }
        }]
      }))
      @site.process
      @document = @site.collections["slides"].docs.first
    end

    should "not know the specified frontmatter defaults" do
      assert_equal({
        "title"=>"Example slide",
        "layout"=>"slide"
      }, @document.data)
    end
  end

  context " a document part of a rendered collection" do
  end

end
