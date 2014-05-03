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

  describe "read_header" do
    let(:read_header) { Archive::Ar::Format.read_header(io) }
    let(:io) { StringIO.new("Filename        1399095295  1234  5678  100644  95        `\n") }
    subject { read_header }

    it {
      subject.should == {
        :name=>"Filename",
        :modified=>Time.parse("2014-05-02 22:34:55 -0700"),
        :owner=>1234,
        :group=>5678,
        :mode=>"100644",
        :start=>60,
        :size=>95,
        :magic=>"`\n"
      }
    }
  end
end
