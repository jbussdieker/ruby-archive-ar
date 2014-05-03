module Archive
  module Ar
    class Format
      class << self
        def read_global_header(io)
          io.read(8).tap do |global_header|
            raise "Invalid header" unless global_header == Archive::Ar::MAGIC
          end
        end

        def read_header(io)
          block = io.read(60)
          h = block.unpack("A16 Z12 a6 a6 A8 Z10 Z2")
          header = {
            :name => h.shift,
            :modified => Time.at(h.shift.to_i),
            :owner => h.shift.to_i,
            :group => h.shift.to_i,
            :mode => h.shift.to_i(8),
            :start => io.tell,
            :size => h.shift.to_i,
            :magic => h.shift,
          }

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
        end
      end
    end
  end
end
