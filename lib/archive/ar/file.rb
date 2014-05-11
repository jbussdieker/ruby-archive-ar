module Archive
  module Ar
    class File
      attr_accessor :name

      def initialize(archive, data)
        @archive = archive
        @data = data
      end

      def name
        @data[:name]
      end

      def read
      end
    end
  end
end
