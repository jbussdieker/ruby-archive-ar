module Archive
  module Ar
    class Member
      def initialize(io, size)
        @io = io
        @size = size
      end

      def to_s
        @io.read(@size)
      end
    end
  end
end
