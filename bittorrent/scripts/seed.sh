#!/bin/sh

if [ "" = "$1" ]; then
  BTFILE=test.dat
else
  BTFILE=$1
fi

dd if=/dev/random of=$BTFILE bs=1024 count=0 seek=1024

btmakemetafile $BTFILE http://192.168.101.1:6969/announce

cp ./${BTFILE}.torrent /vagrant/indexes

btdownloadcurses --saveas $BTFILE http://192.168.101.1:8000/${BTFILE}.torrent
