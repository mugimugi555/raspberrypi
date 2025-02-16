#!/bin/bash
 
set +e
 
systemctl enable ssh
systemctl start ssh
rm -f /boot/firstrun.sh

exit 0
