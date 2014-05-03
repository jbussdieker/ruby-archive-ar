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
          {
            :name => h.shift,
            :modified => Time.at(h.shift.to_i),
            :owner => h.shift.to_i,
            :group => h.shift.to_i,
            :mode => h.shift,
            :start => io.tell,
            :size => h.shift.to_i,
            :magic => h.shift,
          }
        end
      end
    end
  end
end
