#!/usr/bin/bash

# wget

# please create password file to ~/mypassword.txt

myhost_array=(
    "raspberry"
#    "pi1-1"
#    "pi1-2"
#    "pi1-3"
)

cmd_name=$*

if [ ! ${cmd_name} ] ; then

    echo "plese input command name"
    echo "ex) ./filename.sh cmd_name"
    exit

fi

echo "============================"
echo "install app => ${cmd_name}"
echo "============================"

for myhost in ${myhost_array[@]} ; do

    echo "install to server => ${myhost}"
    sshpass -f ~/mypassowrd.txt ssh pi@$myhost.local \
	    "${cmd_name} " \
	    &

done

