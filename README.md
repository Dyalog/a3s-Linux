# APL as a Service (a3s)

This set of scripts will allow you to run a Dyalog APL session as a service on a Linux host.

This is a work-in-progress tool, contributions are welcome via a pull requests.

Currently this supports systemd, upstart and init.d files

## Uses
This could be used to host a MiServer website on a linux server, Dyalog uses this script to launch TryAPL on a linux host.

## Config

The file */etc/default/a3s* has options for setting up the service, which workspace to run, which user to run as, etc.

### Install

We publish the a3s images on packages.dyalog.com for Debian based distros, you can use this repository to install a3s by first adding the repository to your system:

```shell
$ wget -O - http://packages.dyalog.com/dyalog-apt-key.gpg.key | sudo apt-key add -
$ CODENAME=`lsb_release -sc`
$ echo "deb http://packages.dyalog.com ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/dyalog.list
```

Once you have set up the repository you can install a3s using the following:

```shell
$ sudo apt update
$ sudo apt install a3s
```

This will keep a3s up to date with your normal system updates.

### Alternative install

Download the deb file from https://github.com/Dyalog/a3s-Linux/releases and install with:

```shell
$ sudo dpkg -i ./a3s*.deb
```

## Known issues
Currently there is an issue when connecting RIDE to an interpreter running as a daemon, While the RIDE connection works and you can type in to the session, the output is not sent to RIDE currently.
