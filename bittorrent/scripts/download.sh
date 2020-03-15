#!/bin/sh

if [ "" = "$1" ]; then
  BTFILE=test.dat
else
  BTFILE=$1
fi

btdownloadcurses http://192.168.101.1:8000/${BTFILE}.torrent