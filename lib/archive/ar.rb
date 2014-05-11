require "archive/ar/version"
require "archive/ar/archive"
require "archive/ar/file"
require "archive/ar/format"
require "archive/ar/reader"
require "archive/ar/writer"

module Archive
  module Ar
    MAGIC = "!<arch>\n"

    def self.create(dest_file, filenames = [], options = {})
      Writer.new(filenames).write(dest_file, options)
    end

    def self.extract(source_file, dest_dir, options = {})
      Reader.new(source_file, options).extract(dest_dir, options)
    end

    def self.traverse(source_file, options = {}, &block)
      Reader.new(source_file, options).each(&block)
    end

    def self.open(source_file)
      Archive.new(source_file)
    end
  end
end
