#!/bin/bash

NEEDED=10000000
AVALIABLE=`df  /var | awk '{print $3}' | tail -1`


if [ $AVALIABLE -gt $NEEDED ] 
  then 
	echo "syncing new channels for RHS"
	satellite-sync satellite-sync -c rhel-x86_64-server-6.2.z\
				      -c rhel-x86_64-server-6-rhs-2.0\
				      -c rhel-x86_64-server-sfs-6.2.z\
	#Creating an additional Channel 
	spacecmd -- softwarechannel_create -n \'RHS Installtion Channel RHEL6.2\' \
                                              -l rhel-86_64-server-6-6.2-rhs \
                                              -a x86_64\
        rhnpush -c 'rhel-86_64-server-6-6.2-rhs' -d /media/Packages

	#Rsyncing everything except rpm's
	mkdir /var/satellite/rhn/kickstart/ks-rhel-86_64-server-6-6.2-RHS	
	rsync -av --exclude='*.rpm' /media/ /var/satellite/rhn/kickstart/ks-rhel-86_64-server-6-6.2-RHS
	spacecmd -- softwarechannel_create -n \'RHS Installtion Channel RHEL6.2\' \
                                              -l rhel-86_64-server-6-6.2-rhs \
                                              -a x86_64\
	#Creating a Custom Distro for RHS
	rhnpush -c 'rhel-86_64-server-6-6.2-rhs' -d /media/Packages
	spacecmd distribution_create -- -n  -p /var/satellite/rhn/kickstart/ks-rhel-86_64-server-6-6.2-RHS -b rhel-86_64-server-6-6.2-rhs -t rhel_6	

  else
	echo "not enough space in /var/satellite - please ensure at least 15G of free space"
fi
