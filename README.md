# APL as a Service (a3s)

This set of scripts will allow you to run a Dyalog APL session as a service on a Linux host.

### Uses
This could be used to host a MiServer webside on a linux server, Dyalog uses this script to launch TryAPL on a linux host.

### Config

The file */etc/a3s/server.conf* has options for setting up the service, Which workspace to run, which user to run as, etc.

### Install

To install go to http://packages.dyalog.com and set up the repository, you should then be able to run "apt-get install a3s"
