require 'spec_helper'

describe Archive::Ar do
  let(:options) { {} }
  let(:source_file) { "spec/fixtures/archive.a" }

  describe "create" do
    let(:dest_file) { "tmp/create.a" }
    let(:filenames) { ["spec/fixtures/file"] }
    subject { Archive::Ar.create(dest_file, filenames, options) }

    it { should == 66 }
  end

  describe "extract" do
    let(:dest_dir) { "tmp/" }
    subject { Archive::Ar.extract(source_file, dest_dir, options) }

    context "archive.ar" do
      it { should == ["file"] }
    end
  end

  describe "traverse" do
    subject { Archive::Ar.traverse(source_file, options) }

    context "archive.ar" do
      it "yields the file" do
        expect {|b|
          Archive::Ar.traverse(source_file, options, &b)
        }.to yield_successive_args(anything)
      end
    end
  end

  describe "open" do
    subject { Archive::Ar.open(source_file) }

    it { should be_kind_of Archive::Ar::Archive }
  end
end
