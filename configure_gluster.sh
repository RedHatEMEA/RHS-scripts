#!/bin/bash
#
# Setup of RHS on a set of computer
#
# vgeller@redhat.com, 22nd February 2012, Initial Version
# 
#

######### IMPORTANT ###########################
# 
# If you will be using a Satellite, please sync 
# follwing channels to your Sat prior to this installation
# 
# Command: satellite-sync -c rhel-x86_64-server-6.2.z -c rhel-x86_64-server-6-rhs-2.0 -c rhel-x86_64-server-sfs-6.2.z
# 
# Please alose create and activation key with the channels 
#	- RHEL EUS Server (v. 6.2.z for 64-bit x86_64)
#	 - Red Hat Storage Server 2.0 (RHEL 6.2.z for x86_64) 
#	 - RHEL EUS Server Scalable File System (v. 6.2.z for x86_64) 
#
###############################################


#Let s define some variables
GLUSTERHOSTS=
SATELLITEFDQN=satellite.coe.muc.redhat.com
SATELLITEUSER=gpscadmin
SATELLITEPASS=redhat
SATELLITEKEY=4-rhs
GLUSTERPV=/dev/vdb
GLUSTERVG=vg01
GLUSTERLV=brk01
GLUSTEREXPORT=/srv/brk01

echo "##  # #  ##     ### ###  ## ###  #  #   #   " 
echo "# # # # #        #  # # #    #  # # #   #   "
echo "##  ###  #       #  # #  #   #  ### #   #   "
echo "# # # #   #      #  # #   #  #  # # #   #   "
echo "# # # # ##      ### # # ##   #  # # ### ### "

# Register with satellite

if [ -f /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT ]
	then 
		echo "System already with certificate"
	else 
		echo "Getting Certificate"
		wget http://$SATELLITEFDQN/pub/RHN-ORG-TRUSTED-SSL-CERT -P /usr/share/rhn
fi 

rhnreg_ks --activationkey=$SATELLITEKEY --serverUrl=$SATELLITEFDQN

#function registerthehardway {

#wget http://$SATELLITEFDQN/pub/RHN-ORG-TRUSTED-SSL-CERT -P /usr/share/rhn

#rhnreg_ks \
#--serverUrl=http://$SATELLITEFDQN/XMLRPC \
#--sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT \
#--username=$SATELLITEUSER \
#--password=$SATELLITEPASS \

#rhn-channel -u gpscadmin -p redhat -a -c rhel-x86_64-server-6.2.z -c rhel-x86_64-server-sfs-6.2.z -c rhel-x86_64-server-6-rhs-2.0
#}

# Update the install from the repos
yum update -y

# Restart the gluster service
chkconfig glusterd on;service glusterd restart

#create your brick 
pvcreate $GLUSTERPV --force
vgcreate $GLUSTERVG $GLUSTERPV
lvcreate -n $GLUSTERLV -L 2GB $GLUSTERVG
mkfs -t xfs -i size=512 /dev/$GLUSTERVG/$GLUSTERLV
mkdir $GLUSTEREXPORT

#Add correct entry to fstab

echo `xfs_admin -u /dev/$GLUSTERVG/$GLUSTERLV` $GLUSTEREXPORT  xfs  allocsize=4096,inode64 0 0 >> /etc/fstab
