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
            header_to_s(header)
          end

          private

          def header_to_s(header)
            data = ""
            namebuf = header[:name]
            if namebuf.length > 16
              namebuf += "\0" * (4 - namebuf.length % 4) if (namebuf.length % 4) != 0
              data += "%-16s" % "#1/#{namebuf.length}"
              header[:size] += namebuf.length
            else
              data += "%-16s" % header[:name]
            end
            data += "%-12s" % header[:modified]
            data += "%-6s" % header[:owner]
            data += "%-6s" % header[:group]
            data += "%-8s" % header[:mode].to_s(8)
            data += "%-10s" % header[:size]
            data += "%2s" % header[:magic]
            data += namebuf if header[:name].length > 16
            data
          end
        end
      end
    end
  end
end
