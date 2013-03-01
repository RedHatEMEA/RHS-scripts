#!/bin/bash

NEEDED=15000000
AVALIABLE=`df  /var | awk '{print $3}' | tail -1`


if [ $AVALIABLE -gt $NEEDED ] 
  then 
	echo "syncing new channels for RHS"
	satellite-sync satellite-sync -c rhel-x86_64-server-6.2.z\
				      -c rhel-x86_64-server-6-rhs-2.0\
				      -c rhel-x86_64-server-sfs-6.2.z\
	#Rsyncing everything except rpm's
	mkdir /var/satellite/rhn/kickstart/ks-rhel-86_64-server-6-6.2-RHS	
	rsync -av --exclude='*.rpm' /media/ /var/satellite/rhn/kickstart/ks-rhel-86_64-server-6-6.2-RHS
	

  else
	echo "not enough space in /var/satellite - please ensure at least 15G"
fi
