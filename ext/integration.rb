#!/usr/bin/env ruby
AR_COMMAND = 'ar'
ARCHIVE_AR_COMMAND = 'bundle exec ../bin/archive-ar'

def run_test(cmd)
  puts "Testing `ar #{cmd}`"
  out_ar = `#{AR_COMMAND} #{cmd} 2>&1`
  out_archive_ar = `#{ARCHIVE_AR_COMMAND} #{cmd} 2>&1`

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

#run_test("-r test.ar myfile")
#run_test("-t test.ar")
run_test("-tv test.ar")
#run_test("-p test.ar")
#run_test("-pv test.ar")
#run_test("-x test.ar")
#run_test("-xv test.ar")
