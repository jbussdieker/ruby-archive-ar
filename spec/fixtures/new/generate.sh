#!/bin/bash
version=gnu
rm -f a
touch a
rm -f $version-01-basic.a
ar -r $version-01-basic.a a

rm -f aaaaaaaaaaaaaaa
touch aaaaaaaaaaaaaaa
rm -f $version-02-15-char-filename.a
ar -r $version-02-15-char-filename.a aaaaaaaaaaaaaaa 

rm -f aaaaaaaaaaaaaaaa
touch aaaaaaaaaaaaaaaa
rm -f $version-03-16-char-filename.a
ar -r $version-03-16-char-filename.a aaaaaaaaaaaaaaaa

echo "foobar" > b
rm -f $version-04-small-file.a
ar -r $version-04-small-file.a b
