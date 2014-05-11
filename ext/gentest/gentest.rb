#!/usr/bin/env ruby
require 'digest/md5'

index = 0
64.times do
  index += 1
  name = "z" * index
  data = Digest::MD5.hexdigest(Random.rand.to_s)
  File.open(name, "w") do |f|
    f.write(data)
  end

  `ar -rcs test#{"%02d" % index}.a #{name}`
  File.delete(name)
end
