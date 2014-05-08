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

  describe "build_header" do
    let(:file) { "spec/fixtures/file" }
    let(:subject) { Archive::Ar::Format.build_header(file) }

    it { should == "file            1399576012  1001  1001  100664  5         `\n" }
  end

  describe "read_header" do
    let(:read_header) { Archive::Ar::Format.read_header(io) }
    let(:io) { StringIO.new(payload) }
    subject { read_header }

    context "normal" do
      let(:payload) { "#1/8            1399095295  1234  5678  100644  95        `\nFilename" }

      it {
        subject.should == {
          :name=>"Filename",
          :modified=>Time.parse("2014-05-02 22:34:55 -0700"),
          :owner=>1234,
          :group=>5678,
          :mode=>"100644".to_i(8),
          :start=>68,
          :size=>95,
          :magic=>"`\n"
        }
      }
    end

    context "long filename" do
      let(:payload) { "Filename        1399095295  1234  5678  100644  95        `\n" }

      it {
        subject.should == {
          :name=>"Filename",
          :modified=>Time.parse("2014-05-02 22:34:55 -0700"),
          :owner=>1234,
          :group=>5678,
          :mode=>"100644".to_i(8),
          :start=>60,
          :size=>95,
          :magic=>"`\n"
        }
      }
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
