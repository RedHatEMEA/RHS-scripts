RHS-scripts
===========

The purpose if this repo is to provide scipts for installation of RHS.

Contents
--------

 - configure_satellite.sh - downloads all packages needed for RHS


Prereqisites
------------

To install RHS you will need the following:
 
 - A valid RHS subscription
 - Minimum of 4 Servers 
 - Optional Satellite server
 - spacecmd (get nightly build from http://spacewalk.redhat.com/yum/nightly/RHEL/6/x86_64/)

Usage
-----

To automate the installation from the satellite server, you will need to follow the following steps.

 - Download the RHS Installation ISO onto your satellite installation 
 - Make sure that your RHS subscription is installed on the Satellite server
 - Run the configure_satellite.sh scipt. 
 - Create the the distribution on the server 

To automate the installation of the Gluster service






