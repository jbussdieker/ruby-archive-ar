require 'spec_helper'

describe Archive::Ar::Reader do
  let(:source) { File.open("spec/fixtures/test.ar") }
  let(:reader) { Archive::Ar::Reader.new(source, {}) }

  describe "parse" do
    let(:source) { io }
    let(:options) { {} }
    let(:reader) { Archive::Ar::Reader.new(source, options) }
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
          name: "Gemfile",
          modified: Time.at(1399095295),
          owner: 501,
          group: 20,
          mode: "100644".to_i(8),
          start: 68,
          size: 95,
          magic: "`\n",
        }, "ASDF"]} 
      }
    end
  end
end
