module Archive
  module Ar
    class Format
      class GNU < Format
        # GNU Format
        #
        # All filenames are terminated with / to support spaces in filenames.
        # This means the max filename length is 15 characters for GNU.
        # Long filenames are stored in an array at the beginning of the archive.
        # The file name becomes //#{offset}
        class << self
          def read_header(io)
            raise "Not supported"
          end

          private

          def header_to_s(header)
            raise "Not supported"
          end
        end
      end
    end
  end
end
