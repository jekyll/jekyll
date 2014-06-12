require 'spec_helper'

describe(Jekyll::FileSystemAdapter) do

  context "class methods" do
    let(:base_dir)     { source_dir }
    let(:outside_file) { "/etc/passwd" }
    let(:inside_file)  { "resume/index.md" }

    it "sanitizes a questionable path outside the base directory correctly" do
      expect(described_class.sanitized_path(base_dir, outside_file)).to(
        eql(source_dir('etc', 'passwd'))
      )
    end

    it "sanitizes a path inside the base directory correctly" do
      expect(described_class.sanitized_path(base_dir, inside_file)).to(
        eql(source_dir('resume', 'index.md'))
      )
    end
  end

  context "an instance" do
    let(:source) { source_dir }
    let(:safe)   { false }
    let(:site)   { nil }
    subject do
      described_class.new(source_dir, { safe: safe, site: site })
    end

    it "reads in an entire existing file" do
      expect(subject.read(source_dir('homepage.md'))).to eql(<<-FILE
---
title: Home Page
---

Welcome to my homepage!
FILE
)
    end

    it "reads in just some bytes of an existing file" do
      expect(subject.read(source_dir('homepage.md'), { bytes: 5 })).to eql("---\nt")
    end

    it "can tell if a file exists on the filesystem" do
      expect(subject.exist?('homepage.md')).to be_truthy
    end

    it "can tell if a file doesn't exist" do
      expect(subject.exist?('index.md')).to be_falsey
    end

    context "safe mode turned on" do
      let(:safe) { true }

      it "reports safe mode turned on" do
        expect(subject.safe?).to be_truthy
      end
    end

    context "safe mode turned off" do
      let(:safe) { false }

      it "reports safe mode turned on" do
        expect(subject.safe?).to be_falsey
      end
    end

  end

end
