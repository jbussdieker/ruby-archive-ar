# Archive::Ar

[![Gem Version](https://badge.fury.io/rb/archive-ar.svg)](http://badge.fury.io/rb/archive-ar)
[![Build Status](https://travis-ci.org/jbussdieker/ruby-archive-ar.svg)](https://travis-ci.org/jbussdieker/ruby-archive-ar)
[![Code Climate](https://codeclimate.com/github/jbussdieker/ruby-archive-ar.png)](https://codeclimate.com/github/jbussdieker/ruby-archive-ar)
[![Coverage Status](https://coveralls.io/repos/jbussdieker/ruby-archive-ar/badge.png)](https://coveralls.io/r/jbussdieker/ruby-archive-ar)
[![Dependency Status](https://gemnasium.com/jbussdieker/ruby-archive-ar.svg)](https://gemnasium.com/jbussdieker/ruby-archive-ar)

Simple AR file functions

## Installation

Add this line to your application's Gemfile:

    gem 'archive-ar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install archive-ar

## Usage

Create an archive

    ar.rb -r somearchive.ar file1 file2

`````ruby
Archive::Ar.create("somearchive.ar", ["file1", "file2"])
`````

Extract an archive

    ar.rb -x somearchive.ar /tmp

`````ruby
Archive::Ar.extract("somearchive.ar", "/tmp")
`````

Advanced

    ar.rb -t somearchive.ar

`````ruby
Archive::Ar.traverse("somearchive.ar") do |file|
  puts file.name
end
`````

## Contributing

1. Fork it ( http://github.com/jbussdieker/ruby-archive-ar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
