module Archive
  module Ar
    class Archive
      def initialize(source_file)
        @source_file = source_file
      end

      def files
        @files ||= (
          list = []
          reader.each do |file|
            list << File.new(self, file)
          end
          list
        )
      end

      def [](key)
        files.each do |file|
          if file.name == key
            return file
          end
        end
        nil
      end

      private

      def reader
        @reader ||= Reader.new(@source_file, {})
      end
    end
  end
end
