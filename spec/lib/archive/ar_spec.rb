require 'spec_helper'

describe Archive::Ar do
  let(:options) { {} }

  describe "create" do
    let(:dest_file) { "tmp/create.ar" }
    let(:filenames) { ["spec/fixtures/file"] }
    subject { Archive::Ar.create(dest_file, filenames, options) }

    it { should == 66 }
  end

  describe "extract" do
    let(:dest_dir) { "tmp/" }
    subject { Archive::Ar.extract(source_file, dest_dir, options) }

    context "archive.ar" do
      let(:source_file) { "spec/fixtures/archive.ar" }

      it { should == ["file"] }
    end
  end

  describe "traverse" do
    subject { Archive::Ar.traverse(source_file, options) }

    context "archive.ar" do
      let(:source_file) { "spec/fixtures/archive.ar" }

      it "yields the file" do
        expect {|b|
          Archive::Ar.traverse(source_file, options, &b)
        }.to yield_successive_args(anything)
      end
    end
  end
end
