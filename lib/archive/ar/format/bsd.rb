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
            list = render_list(header)
            list.collect { |format, data| format % data }.join
          end

          private

          def pad_name(name)
            namebuf = name
            if (namebuf.length % 4) != 0
              namebuf += "\0" * (4 - namebuf.length % 4)
            end
            namebuf
          end

          def adjust_header(header)
            header[:long_name] = ""

            if header[:name].length > 16
              namebuf = pad_name(name)
              header[:name] = "#1/#{namebuf.length}"
              header[:long_name] = namebuf
              header[:size] += namebuf.length
            end

            header
          end

          def render_list(header)
            [
              "%-16s", header[:name],
              "%-12s", header[:modified],
              "%-6s", header[:owner],
              "%-6s", header[:group],
              "%-8s", header[:mode].to_s(8),
              "%-10s", header[:size],
              "%2s", header[:magic],
              "%s", header[:long_name],
            ]
          end
        end
      end
    end
  end
end
