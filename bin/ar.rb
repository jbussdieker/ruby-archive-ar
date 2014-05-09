#!/usr/bin/env ruby
require 'archive/ar'
require 'optparse'

######## HACK ALERT #################
# TODO: Make this a gem or something
#####################################
def short_mode(value)
  str = "---"
  str[0] = "r" if value & 4 == 4
  str[1] = "w" if value & 2 == 2
  str[2] = "x" if value & 1 == 1
  str
end

def mode(value)
  r = ""
  everyone = short_mode(value)
  value = value >> 3
  group = short_mode(value)
  value = value >> 3
  owner = short_mode(value)
  "#{owner}#{group}#{everyone}"
end
#####################################

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: archive-ar [options]"

  opts.on("-t", "List the specified files in the order in which they appear in the archive, each on a
             separate line.  If no files are specified, all files in the archive are listed.") do |v|
    options[:t] = v
  end

  opts.on("-x", "Extract the specified archive members into the files named by the command line argu-
             ments.  If no members are specified, all the members of the archive are extracted into
             the current directory.

             If the file does not exist, it is created; if it does exist, the owner and group will
             be unchanged.  The file access and modification times are the time of the extraction
             (but see the -o option).  The file permissions will be set to those of the file when
             it was entered into the archive; this will fail if the user is not the owner of the
             extracted file or the super-user.") do |v|
    options[:x] = v
  end

  opts.on("-p", "Write the contents of the specified archive files to the standard output.  If no files
             are specified, the contents of all the files in the archive are written in the order
             they appear in the archive.") do |v|
    options[:p] = v
  end

  opts.on("-r", "Replace or add the specified files to the archive.  If the archive does not exist a new archive file
             is created.  Files that replace existing files do not change the order of the files within the ar-
             chive.  New files are appended to the archive unless one of the options -a, -b or -i is specified.") do |v|
    options[:r] = v
  end

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

if options[:p]
  raise "illegal option combination for -p" if options[:t]
  raise "illegal option combination for -p" if options[:x]
  raise "illegal option combination for -p" if options[:r]

  Archive::Ar.traverse(ARGV[0]) do |header, data|
    if options[:verbose]
      puts
      puts "<#{header[:name]}>"
      puts
    end
    puts data
  end
elsif options[:r]
  raise "illegal option combination for -r" if options[:t]
  raise "illegal option combination for -r" if options[:x]

  filename = ARGV.shift
  unless File.exists?(filename)
    puts "ar: creating archive #{filename}"
    Archive::Ar.create(filename, ARGV)
  else
    puts "we only support create"
    exit 1
  end
elsif options[:t]
  raise "illegal option combination for -t" if options[:x]

  Archive::Ar.traverse(ARGV[0]) do |header, data|
    if options[:verbose]
      print mode(header[:mode])
      print " "
      og = "#{header[:owner]}/#{header[:group]}"
      print "%10s" % og
      print " "
      print "%12s" % header[:size]
      print " "
      print header[:modified].strftime("%b %e %R %Y")
      print " "
      print header[:name]
      puts
    else
      puts header[:name]
    end
  end
elsif options[:x]
  if options[:verbose]
    Archive::Ar.traverse(ARGV[0]) do |header, data|
      puts "x - #{header[:name]}"
      Archive::Ar::Format.extract_file(Dir.pwd, header, data)
    end
  else
    Archive::Ar.extract(ARGV[0], Dir.pwd)
  end
end

#p options
#p ARGV
