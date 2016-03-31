require 'spec_helper'

RSpec.describe(Jekyll::Errors) do
  it "defines the base exception, FatalException" do
    expect(described_class).to be_const_defined(:FatalException)
  end
end
