#!/usr/bin/env ruby
require 'digest/md5'
require 'fileutils'

AR_COMMAND = 'ar'
ARCHIVE_AR_COMMAND = 'bundle exec ../bin/ar.rb'

def run_test(cmd, md5file = nil)
  puts "Testing `ar #{cmd}`"

  # Test original
  out_ar = `#{AR_COMMAND} #{cmd} 2>&1`
  if md5file
    md5_ar = Digest::MD5.file(md5file)
    FileUtils.rm_rf(md5file)
  end

  # Test ruby version
  out_archive_ar = `#{ARCHIVE_AR_COMMAND} #{cmd} 2>&1`
  if md5file
    md5_archive_ar = Digest::MD5.file(md5file)
    FileUtils.rm_rf(md5file)
  end

  if md5_ar != md5_archive_ar
    puts " Error #{cmd}"
    puts " File mismatch:"
    puts "   Expected: #{md5_ar}"
    puts "        Got: #{md5_archive_ar}"
  end

  if out_ar != out_archive_ar
    puts " Error #{cmd}"
    puts " Expected:"
    out_ar.split("\n").each {|l| puts "  | #{l}"}
    puts " Got:"
    out_archive_ar.split("\n").each {|l| puts "  | #{l}"}
    false
  else
    true
  end
end

run_test("-r integration-temp.ar myfile", "integration-temp.ar")
run_test("-r integration-temp.ar abcdefghijklmnopqrstuvwxyz", "integration-temp.ar")
run_test("-r integration-temp.ar myfile.even", "integration-temp.ar")
run_test("-r integration-temp.ar myfile myfile.even", "integration-temp.ar")
run_test("-r integration-temp.ar aaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbb cccccccccccccccccc ddddddddddddddddddd eeeeeeeeeeeeeeeeeeee fffffffffffffffffffff gggggggggggggggggggggg", "integration-temp.ar")
run_test("-t test.ar")
run_test("-tv test.ar")
run_test("-p test.ar")
run_test("-pv test.ar")
run_test("-x test.ar")
run_test("-xv test.ar")
