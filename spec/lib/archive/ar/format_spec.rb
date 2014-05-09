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
    let(:timestamp) { "%-12s" % File.mtime(file).to_i }
    let(:owner) { "%-6s" % File.stat(file).uid }
    let(:group) { "%-6s" % File.stat(file).gid }
    let(:mode) { "%-8s" % File.stat(file).mode.to_s(8) }
    let(:subject) { Archive::Ar::Format.build_header(file) }

    context "normal single file" do
      let(:file) { "spec/fixtures/file" }
      it { should == "file            #{timestamp}#{owner}#{group}#{mode}5         `\n" }
    end

    context "long name single file" do
      let(:file) { "spec/fixtures/abcdefghijklmnopqrstuvwxyz" }
      it { should == "#1/26           #{timestamp}#{owner}#{group}#{mode}0         `\nabcdefghijklmnopqrstuvwxyz" }
    end
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
