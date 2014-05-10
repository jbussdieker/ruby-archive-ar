require 'spec_helper'

describe Archive::Ar::Writer do
  let(:filenames) { [] }
  let(:dest_file) { "tmp/test.a" }
  let(:writer) { Archive::Ar::Writer.new(filenames) }

  describe "write" do
    context "no files" do
      it "works" do
        writer.write(dest_file)
      end
    end

    context "one file" do
      let(:filenames) { ["spec/fixtures/file"] }
      let(:dest_file) { "tmp/test-one.a" }

      it "works" do
        writer.write(dest_file)
      end
    end
  end
end
