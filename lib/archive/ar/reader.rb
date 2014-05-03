module Archive
  module Ar
    class Reader
      def initialize(source, options)
        @source = source 
        @options = options
      end

      def extract(dest_dir, options)
      end

      def each(full = false, &block)
        case @source
          when IO
            parse(@source, full); @source.rewind
          else
            File.open(@source, 'r') { |f| parse(f, full) }
        end

        @index.each { |path| yield *(@records[path]) }
      end

      def parse(io, full = false)
        @index = []
        @records = {}

        Archive::Ar::Format.read_global_header(io)
        
        until io.eof?
          header = Archive::Ar::Format.read_header(io)
          size = header[:size]
          name = header[:name]

          @index << name
          @records[name] = [header, io.read(size)]

          # Data sections are 2 byte aligned
          if size % 2 == 1
            io.read(1)
          end
        end

        @records
      end
    end
  end
end
