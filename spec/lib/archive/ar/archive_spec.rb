require 'spec_helper'

describe Archive::Ar::Archive do
  let(:source_file) { "spec/fixtures/archive.a" }
  let(:archive) { Archive::Ar::Archive.new(source_file) }

  describe "files" do
    subject { archive.files }

    its(:length) { should == 1 }
  end

  describe "[]" do
    context "good ref" do
      subject { archive["file"] }

      it { should be_kind_of Archive::Ar::File }
    end

    context "bad ref" do
      subject { archive["filethanisntthere"] }

      it { should == nil }
    end
  end
end
