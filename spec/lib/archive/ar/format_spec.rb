require 'spec_helper'

describe Archive::Ar::Format do
  describe "read_global_header" do
    let(:read_global_header) { Archive::Ar::Format.read_global_header(io) }
    subject { read_global_header }

    context "when valid" do
      let(:io) { StringIO.new("!<arch>\n") }

      it { should == "!<arch>\n" }
    end

    context "when invalid" do
      let(:io) { StringIO.new("") }

      it "should raise exception" do
        expect { subject }.to raise_error
      end
    end
  end

  describe "extract_file" do
    let(:dest_dir) { "tmp/" }
    let(:header) { { :name => "file", :mode => 0100644 } }
    let(:data) { "test" }
    let(:options) { {} }
    subject { Archive::Ar::Format.extract_file(dest_dir, header, data, options) }

    it { should == true }
  end
end
