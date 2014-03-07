require 'spec_helper'

describe(Jekyll::Collection) do
  let(:site)           { fixture_site }
  let(:collection)     { described_class.new(site, name) }

  context "for the posts collection" do
    let(:name)           { "posts" }
    let(:containing_dir) { source_dir("_posts") }

    it "knows what the constant for the class should be" do
      expect(collection.klass_for_collection).to eq(Jekyll::Post)
    end

    it "knows where the files are stored" do
      expect(collection.directory).to eql(containing_dir)
    end

    it "reads the documents properly" do
      expect(collection.read_documents).to be_a(Array)
    end

    it "reads in every valid file" do
      expect(collection.read_documents.size).to be(37)
    end

    it "reads in documents which are posts" do
      collection.documents.each do |post|
        expect(post).to be_a(Jekyll::Post)
      end
    end

    it "knows to use Jekyll::Post as the class for the collection documents" do
      expect(collection.klass_for_collection).to eql(Jekyll::Post)
    end
  end

  context "for the sass collection" do
    let(:name)           { "sass" }
    let(:containing_dir) { source_dir("_sass") }

    it "reads in all the sass files" do
      expect(collection.documents).to be_a(Array)
      expect(collection.documents.size).to be(1)
    end

    it "reads in the sass files as Jekyll::Document instances" do
      collection.documents.each do |post|
        expect(post).to be_a(Jekyll::Document)
      end
    end

    it "knows to use Jekyll::Document as the class for the collection documents" do
      expect(collection.klass_for_collection).to eql(Jekyll::Document)
    end
  end
end
