#!/bin/bash
version=gnu
echo "foo" > a
rm -f $version-01-basic-even-size.a
ar -r $version-01-basic-even-size.a a

echo "foobar" > aa
rm -f $version-02-basic-odd-size.a
ar -r $version-02-basic-odd-size.a aa

echo "foobar" > "a b c"
rm -f $version-03-space-in-filename.a
ar -r $version-03-space-in-filename.a "a b c"

echo "foobar" > aaaaaaaaaaaaaaa
rm -f $version-04-15-char-filename.a
ar -r $version-04-15-char-filename.a aaaaaaaaaaaaaaa 

echo "foobar" > aaaaaaaaaaaaaaaa
rm -f $version-05-16-char-filename.a
ar -r $version-05-16-char-filename.a aaaaaaaaaaaaaaaa

echo "foobar" > aaaaaaaaaaaaaaaaa
rm -f $version-06-17-char-filename.a
ar -r $version-06-17-char-filename.a aaaaaaaaaaaaaaaaa

echo "foobar" > aaaaaaaaaaaaaaaaaa
rm -f $version-07-18-char-filename.a
ar -r $version-07-18-char-filename.a aaaaaaaaaaaaaaaaaa

echo "foobar" > aaaaaaaaaaaaaaaaaaa
rm -f $version-08-19-char-filename.a
ar -r $version-08-19-char-filename.a aaaaaaaaaaaaaaaaaaa

echo "foobar" > aaaaaaaaaaaaaaaaaaaa
rm -f $version-09-20-char-filename.a
ar -r $version-09-20-char-filename.a aaaaaaaaaaaaaaaaaaaa

echo "foobar" > aaaaaaaaaaaaaaaaaaaa
rm -f $version-10-multiple-long-filenames.a
ar -r $version-10-multiple-long-filenames.a aaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaa

echo "foobar" > b
rm -f $version-11-small-file.a
ar -r $version-11-small-file.a b
