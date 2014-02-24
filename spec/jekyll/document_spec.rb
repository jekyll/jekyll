require 'spec_helper'

describe(Jekyll::Document) do
  let(:site)           { fixture_site }
  let(:name)           { "cats_and_dogs" }
  let(:containing_dir) { source_dir("_animals") }
  let(:document)       { described_class.new(site, containing_dir, name) }

  it "knows what the constant for the class should be" do
    expect(document.klass_for_document).to eq(:CatsAndDogs)
  end
end
