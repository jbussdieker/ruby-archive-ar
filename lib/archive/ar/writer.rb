module Archive
  module Ar
    class Writer
      def initialize(filenames)
        @filenames = filenames
        @format = Archive::Ar::Format::BSD
      end

      def build_ar_entry(file)
        header = @format.build_header(file)
        data = File.read(file)
        data += "\n" if (data.length + header.length) % 2 == 1
        [header, data].join
      end

      def build_ar
        @filenames.collect do |f|
          build_ar_entry(f)
        end
      end

      def write(dest_file, options = {})
        File.open(dest_file, 'w') do |f|
          data = build_ar.join("")
          f.write(Archive::Ar::MAGIC)
          f.write(data)
        end
      end
    end
  end
end
