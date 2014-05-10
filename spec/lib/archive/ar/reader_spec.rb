require 'spec_helper'

describe Archive::Ar::Reader do
  let(:options) { {} }
  let(:source) { io }
  let(:io) { File.open("spec/fixtures/archive.a") }
  let(:reader) { Archive::Ar::Reader.new(source, options) }

  describe "extract" do
    let(:dest_dir) { "tmp/" }
    let(:options) { {} }
    subject { reader.extract(dest_dir, options) }

    it { should == ["file"] }
  end

  describe "each" do
    context "using IO" do
      let(:io) { File.open("spec/fixtures/archive.a") }

      it "yields anything once" do
        expect {|b|
          reader.each(&b)
        }.to yield_successive_args(anything)
      end
    end

    context "using String" do
      let(:io) { "spec/fixtures/archive.a" }

      it "yields anything once" do
        expect {|b|
          reader.each(&b)
        }.to yield_successive_args(anything)
      end
    end
  end

  describe "parse" do
    subject { reader.parse(io) }

    context "empty" do
      let(:io) { StringIO.new("") }
      it "should raise exception" do
        expect { subject }.to raise_error
      end
    end

    context "global header only" do
      let(:io) { StringIO.new("!<arch>\n") }
      it { should == {} }
    end

    context "one file" do
      let(:io) { StringIO.new("!<arch>\nGemfile         1399095295  501   20    100644  95        `\nASDF") }
      it { 
        should == { "Gemfile" => [{
          :name => "Gemfile",
          :modified => Time.at(1399095295),
          :owner => 501,
          :group => 20,
          :mode => "100644".to_i(8),
          :start => 68,
          :size => 95,
          :magic => "`\n",
        }, "ASDF"]} 
      }
    end
  end
end
