require 'spec_helper'

describe(Jekyll::Document) do
  let(:site)           { fixture_site }
  let(:name)           { "animals" }
  let(:collection)     { Jekyll::Collection.new(site, name) }
  let(:document)       { new_document.call("lion.md") }
  let(:new_document)   { ->(filename){ described_class.new(site, collection, filename) } }

  it "knows the site to which it belongs" do
    expect(document.site).to eql(site)
  end

  it "knows which collection to which it belongs" do
    expect(document.collection).to eql(collection)
  end

  it "can read in itself" do
    expect(document.read).to be_true
  end

  it "knows its relative path" do
    expect(document.relative_path).to eql("_animals/lion.md")
  end

  it "knows its absolute path" do
    expect(document.absolute_path).to eql(source_dir("_animals/lion.md"))
  end

  it "knows its id" do
    expect(document.id).to eql(document.relative_path)
  end

  it "has a unique inspect string" do
    expect(document.inspect).to eql("<Jekyll::Document(#{document.relative_path})>")
  end

  context "when read in" do
    before(:each) { document.read }

    it "knows its content" do
      expect(document.content).to eql("The lion is a mighty cat, not to be messed with. :growl:\n")
    end

    it "knows its data" do
      expect(document.data).to eql({
        "title" => "Lion",
        "myKey" => "this is the random key I'm setting"
      })
    end
  end

end
