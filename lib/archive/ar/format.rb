require 'archive/ar/format/bsd'
require 'archive/ar/format/gnu'

module Archive
  module Ar
    class Format
      class << self
        def read_global_header(io)
          io.read(8).tap do |global_header|
            raise "Invalid header" unless global_header == Archive::Ar::MAGIC
          end
        end

        def extract_file(dest_dir, header, data, options = {})
          file = File.join(dest_dir, header[:name])

          File.open(file, "w") do |f|
            f.write(data)
          end

          File.chmod(header[:mode], file)
          #FileUtils.chown(header[:owner], header[:group], file)

          true
        end

        def build_header(file)
          header = read_file_header(file)
          header_to_s(header)
        end

        private

        def read_file_header(file)
          {
            :name => File.basename(file),
            :modified => File.mtime(file).to_i,
            :owner => File.stat(file).uid,
            :group => File.stat(file).gid,
            :mode => File.stat(file).mode,
            :size => File.size(file),
            :magic => "`\n"
          }
        end

        def parse_header(data)
          h = data.unpack("A16 Z12 a6 a6 A8 Z10 Z2")
          {
            :name => h.shift.chomp("/"), # Remove trailing slash. GNU archives have this...
            :modified => Time.at(h.shift.to_i),
            :owner => h.shift.to_i,
            :group => h.shift.to_i,
            :mode => h.shift.to_i(8),
            :size => h.shift.to_i,
            :magic => h.shift,
          }
        end
      end
    end
  end
end
