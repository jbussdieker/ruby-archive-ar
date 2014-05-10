module Archive
  module Ar
    class Format
      class << self
        def read_global_header(io)
          io.read(8).tap do |global_header|
            raise "Invalid header" unless global_header == Archive::Ar::MAGIC
          end
        end

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

        def build_header(file)
          header = read_file_header(file)
          header_to_s(header)
        end

        def parse_header(data)
          h = data.unpack("A16 Z12 a6 a6 A8 Z10 Z2")
          {
            :name => h.shift.chomp("/"), # Remove trailing slash. Some archives have this...
            :modified => Time.at(h.shift.to_i),
            :owner => h.shift.to_i,
            :group => h.shift.to_i,
            :mode => h.shift.to_i(8),
            :size => h.shift.to_i,
            :magic => h.shift,
          }
        end

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

        def extract_file(dest_dir, header, data, options = {})
          file = File.join(dest_dir, header[:name])

          File.open(file, "w") do |f|
            f.write(data)
          end

          File.chmod(header[:mode], file)
          #FileUtils.chown(header[:owner], header[:group], file)

          true
        end
      end
    end
  end
end
