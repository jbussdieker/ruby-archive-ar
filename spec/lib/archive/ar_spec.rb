require 'spec_helper'

describe Archive::Ar do
  describe "create" do
  end

  describe "extract" do
  end

  describe "traverse" do
    let(:options) { {} }
    subject { Archive::Ar.traverse(source_file, options) }

    context "test.ar" do
      let(:source_file) { "spec/fixtures/test.ar" }

      it "yields two things" do
        expect {|b|
          Archive::Ar.traverse(source_file, options, &b)
        }.to yield_successive_args(anything, anything)
      end
    end
  end
end
