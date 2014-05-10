module Archive
  module Ar
    class Format
      class BSD < Format
        # BSD Format
        #
        # Long file names and filenames containing spaces use #1/#{string_len}
        # The actual file name directly follows the file header and is often 4 byte 
        # aligned by padding with \0
        class << self
          def read_header(io)
            block = io.read(60)
            header = parse_header(block)
            header.merge! :start => io.tell

            if header[:name].start_with? "#1/"
              long_size = header[:name][3..-1].to_i
              header[:start] += long_size
              header[:name] = io.read(long_size).strip
            end

            header
          end

          def build_header(file)
            header = read_file_header(file)
            header = adjust_header(header)
            header_to_s(header)
          end

          private

          def adjust_header(header)
            if header[:name].length > 16
              namebuf = header[:name]
              namebuf += "\0" * (4 - namebuf.length % 4) if (namebuf.length % 4) != 0
              header[:size] += namebuf.length
              header[:long_name] = namebuf
              header[:name] = "#1/#{namebuf.length}"
            end
            header
          end

          def header_to_s(header)
            data = ""
            data += "%-16s" % header[:name]
            data += "%-12s" % header[:modified]
            data += "%-6s" % header[:owner]
            data += "%-6s" % header[:group]
            data += "%-8s" % header[:mode].to_s(8)
            data += "%-10s" % header[:size]
            data += "%2s" % header[:magic]
            data += header[:long_name] if header[:long_name]
            data
          end
        end
      end
    end
  end
end
