require 'spec_helper' 

describe Archive::Ar::Format::BSD do
  describe "read_header" do
    let(:read_header) { Archive::Ar::Format::BSD.read_header(io) }
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

  describe "build_header" do
    let(:timestamp) { "%-12s" % File.mtime(file).to_i }
    let(:owner) { "%-6s" % File.stat(file).uid }
    let(:group) { "%-6s" % File.stat(file).gid }
    let(:mode) { "%-8s" % File.stat(file).mode.to_s(8) }
    let(:subject) { Archive::Ar::Format::BSD.build_header(file) }

    context "normal single file" do
      let(:file) { "spec/fixtures/file" }
      it { should == "file            #{timestamp}#{owner}#{group}#{mode}5         `\n" }
    end

    context "long name single file" do
      let(:file) { "spec/fixtures/abcdefghijklmnopqrstuvwxyz" }
      it { should == "#1/28           #{timestamp}#{owner}#{group}#{mode}28        `\nabcdefghijklmnopqrstuvwxyz\0\0" }
    end
  end
end
