require 'spec_helper'

describe(Jekyll::PageReader) do
  let(:site)   { fixture_site }
  let(:reader) { Jekyll::PageReader.new(site) }
  let(:pages)  { reader.read }

  it "builds a collection with a relative_directory of nothing" do
    expect(reader.pages_collection).to be_a(Jekyll::Collection)
    expect(reader.pages_collection.relative_directory).to eql("")
  end

  it "reads in the Jekyll::Page's" do
    expect(pages).to be_a(Jekyll::Collection)
    pages.each do |page|
      expect(page).to be_a(Jekyll::Page)
    end
  end
end
