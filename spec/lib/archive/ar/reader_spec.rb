require 'spec_helper'

describe Archive::Ar::Reader do
  let(:source) { File.open("spec/fixtures/test.ar") }
  let(:reader) { Archive::Ar::Reader.new(source, {}) }

  it "workds" do
    reader.each do |header, data|
      p header
      p data
    end
  end
end
