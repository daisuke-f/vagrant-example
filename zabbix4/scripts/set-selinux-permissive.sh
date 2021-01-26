#!/bin/sh

if [ `getenforce` = Enforcing ]; then
  pushd /etc/selinux
  cp --preserve ./config ./config.bak
  sed --regexp-extended 's/^\s*(SELINUX=).*/\1permissive/' ./config.bak >./config
  setenforce permissive
  popd
fi
