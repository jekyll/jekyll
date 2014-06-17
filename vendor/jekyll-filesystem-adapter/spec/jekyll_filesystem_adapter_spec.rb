require 'spec_helper'

describe(Jekyll::FileSystemAdapter) do

  context "class methods" do
    let(:base_dir)     { source_dir }
    let(:outside_file) { "/etc/passwd" }
    let(:inside_file)  { "resume/index.md" }

    context ".sanitized_path" do
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
  end

  context "an instance" do
    let(:source) { source_dir }
    let(:safe)   { false }
    let(:site)   { nil }
    subject do
      described_class.new(source_dir, { safe: safe, site: site })
    end

    context "#realpath" do
      it "reads the destination of symlinks" do
        expect(subject.realpath(source_dir('symlink.md'))).to eql(source_dir('homepage.md'))
      end

      it "errors if the file isn't there" do
        expect(->{ subject.realpath(source_dir('non_existent_file.txt')) }).to raise_error
      end
    end

    context "#symlink?" do
      it "knows that a symlink is a symlink" do
        expect(subject.symlink?('symlink.md')).to be_truthy
      end

      it "knows that a regular file is not a symlink" do
        expect(subject.symlink?('homepage.md')).to be_falsey
      end
    end

    context "#file?" do
      it "knows a file is a file" do
        expect(subject.file?('homepage.md')).to be_truthy
      end

      it "knows a directory is not a file" do
        expect(subject.file?('about')).to be_falsey
      end

      it "knows a non-existent file is a not a file" do
        expect(subject.file?('non_existent_file.md')).to be_falsey
      end

      it "prevents traversal outside base directory" do
        expect(subject.file?('/etc/hosts')).to be_falsey
      end
    end

    context "#directory?" do
      it "knows a file is not a directory" do
        expect(subject.directory?('homepage.md')).to be_falsey
      end

      it "knows a directory is a directory" do
        expect(subject.directory?('about')).to be_truthy
      end

      it "knows a non-existent directory is a not a directory" do
        expect(subject.directory?('i-dont-exist')).to be_falsey
      end

      it "prevents traversal outside base directory" do
        expect(subject.directory?('/etc')).to be_falsey
      end
    end

    context "#sanitized_path" do
      it "assumes the base path of the instance" do
        expect(subject.sanitized_path('homepage.md')).to start_with(source_dir)
      end

      it "allows you to put through a base path if you want, too" do
        expect(subject.sanitized_path(tmp_dir, 'homepage.md')).to start_with(tmp_dir)
      end

      it "errors with more than 2 arguments" do
        expect(->{ subject.sanitized_path(tmp_dir, 'homepage', 'the thing.md') }).to raise_error
      end
    end

    context "#read" do
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
    end

    context "#exist?" do
      it "can tell if a file exists on the filesystem" do
        expect(subject.exist?('homepage.md')).to be_truthy
      end

      it "can tell if a file doesn't exist" do
        expect(subject.exist?('index.md')).to be_falsey
      end
    end

    context "#glob" do
      it "grabs the right number of files from a directory" do
        expect(subject.glob('about/**/*').size).to eql(2)
      end

      it "grabs the right files" do
        expect(
          -> {
            subject.chdir(source_dir('about')) do
              subject.glob('about/**/*')
            end
          }.call
        ).to eql(
          %w(hansel.md index.md)
        )
      end

      it "can grab subdirectories" do
        expect(
          subject.glob('**/*')
        ).to eql(
          %w(about about/hansel.md about/index.md homepage.md symlink.md)
        )
      end
    end

    context "#dir_entries" do
      it "grabs just the entries in the immediate folder" do
        expect(subject.dir_entries(source_dir)).to eql(
          %w(about homepage.md symlink.md)
        )
      end
    end

    context "#rm_rf" do
      subject do
        described_class.new(tmp_dir, { safe: safe, site: site })
      end
      let(:all_files)       { [tmp_dir('not_exist')] + files_to_create }
      let(:files_to_create) { [tmp_dir('exit'), tmp_dir('exist')] }
      before(:each) do
        FileUtils.touch files_to_create
      end

      it "deletes only the files that exist" do
        expect(subject.rm_rf(all_files)).to eql(files_to_create)
      end
    end

    context "#mkdir_p" do
      after(:each) do
        subject.rm_rf('etc')
      end

      it "creates a folder" do
        expect(subject.mkdir_p('/etc/hosts')).to eql([source_dir('etc/hosts')])
      end
    end

    context "safe mode turned on" do
      let(:safe) { true }

      context "#file_allowed?" do
        it "reports that a symlinked file isn't allowed" do
          expect(subject.file_allowed?('symlink.md')).to be_falsey
        end

        it "reports that a normal file is allowed" do
          expect(subject.file_allowed?('homepage.md')).to be_truthy
        end
      end

      context "#safe?" do
        it "reports safe mode turned on" do
          expect(subject.safe?).to be_truthy
        end
      end
    end

    context "safe mode turned off" do
      let(:safe) { false }

      context "#file_allowed?" do
        it "reports that a symlinked file is allowed" do
          expect(subject.file_allowed?('symlink.md')).to be_truthy
        end

        it "reports that a normal file is allowed" do
          expect(subject.file_allowed?('homepage.md')).to be_truthy
        end
      end

      context "#safe" do
        it "reports safe mode turned off" do
          expect(subject.safe?).to be_falsey
        end
      end
    end

  end

end
