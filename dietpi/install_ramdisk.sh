#!/usr/bin/bash

mkdir /tmp/myramdisk ;
mount -t tmpfs -o size=10M tmpfs /tmp/myramdisk ;

echo "tmpfs /tmp/myramdisk tmpfs defaults,size=10240k 0 0" | tee -a /etc/fstab ;
