#!/bin/ruby
# Frozen-String-Literal: true
# Encoding: UTF-8

require "rspec/helper"
describe Jekyll::Utils do
  include_context :jekyll

  before do
    mocked_jekyll.fixture.to_site
  end

  #

  describe "#deep_merge_hashes" do
    it "should be able to merge basic hashes" do
      expect(subject.deep_merge_hashes({}, :hello => :world)).to eq({
        :hello => :world
      })
    end

    #

    context "merging complex hashes" do
      subject do
        hash1 = { :hello => { :world1 => :all }}
        hash2 = { :hello => { :world2 => :all }}
        described_class.deep_merge_hashes(
          hash1, hash2
        )
      end

      #

      specify { expect(subject[:hello]).to include :world1 => :all }
      specify { expect(subject[:hello]).to include :world2 => :all }
    end

    #

    context "when merging drops and hashes" do
      let :data do
        {
          "page" => {}
        }
      end

      #

      subject do
        described_class.deep_merge_hashes(
          data, mocked_jekyll.to_site.site_payload
        )
      end

      #

      it { is_expected.to have_key "site" }
      specify { expect(subject["site"]).to be_a Jekyll::Drops::SiteDrop }
      it { is_expected.to be_a Hash }
    end
  end

  #

  describe "#pluralized_array_from_hash" do
    subject do
      described_class.method(
        :pluralized_array_from_hash
      )
    end

    let :data do
      {
        1 => {},
        2 => {
          "foo" => "bar"
        },

        3 => {
          "foo"  => "bar",
          "tag"  =>  nil ,
          "tags" => [
            "dog", "cat"
          ]
        },

        4 => {
          "foo"  => "bar",
          'tag'  => "dog",
          "tags" => [
            "dog", "cat"
          ]
        }
      }
    end

    specify { expect(subject.call(data[1], "tag", "tags")).to eq [] }
    specify { expect(subject.call(data[2], "tag", "tags")).to eq [] }
    specify { expect(subject.call(data[3], "tag", "tags")).to eq ["dog", "cat" ]}
    specify { expect(subject.call(data[4], "tag", "tags")).to eq ["dog"] }
  end
end
