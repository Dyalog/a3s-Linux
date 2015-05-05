#!/bin/bash

mkdir -p debian/DEBIAN

BASE_VERSION="0.2"
VERSION="${BASE_VERSION}.`git rev-list HEAD --count`"

umask 0022

if [ "`git tag`" = "" ]; then echo 

cat >debian/DEBIAN/changelog <<.
a3s ($VERSION) stable; urgency=low

 * First Release
-- Dyalog Ltd <support@dyalog.com>  $(date -R)
.

else

cat >debian/DEBIAN/changelog <<.
a3s ($VERSION) stable; urgency=low
$( (git log --format='%s' $(git tag | tail -n 1).. ) \
	| sed "s/^/ * /"
)
-- Dyalog Ltd <support@dyalog.com $(date -R)

.

fi

git tag -a v${VERSION} -m "tag version ${VVERSION}"

cat >debian/DEBIAN/copyright <<.
Copyright Dyalog Ltd 1982-$(date +%Y)

Dyalog Ltd
Minchens Court
Minchens Lane
Bramley
Hampshire
RG26 5BH

This product may only be used under the conditions stated in the Licence Agreement.  More specifically, you may not resell or distribute any part of this application without the prior agreement of Dyalog Ltd.

This application is NOT part of the Debian GNU/Linux distribution and should NOT be added to ANY online or offline repositories.
.

mkdir -p debian/usr/share/doc/a3s

cp debian/DEBIAN/copyright debian/usr/share/doc/a3s

cat >debian/DEBIAN/control <<.
Package: a3s
Priority: extra
Section: utils
Installed-size: 28
Maintainer: Jason Rivers <jason@dyalog.com>
Homepage: http://www.dyalog.com
Architecture: all
Version: $VERSION
Provides: a3s
Description: APL As a Service
 This package allows a user of Dyalog APL to run APL As a Service at system boot. This includes running a MiServer application.

.

cat >debian/DEBIAN/postinst <<.
#!/bin/bash
set -e

mkdir -p /var/log/a3s

if ! grep "^a3s" /etc/passwd >/dev/null 2>&1; then
	useradd -r -d /var/run/a3s -m -s /bin/false a3s
else
	echo "a3s user exists -- skipping"
fi

/usr/sbin/update-rc.d a3s defaults

exit 0

.

chmod +x debian/DEBIAN/postinst

cat >debian/DEBIAN/prerm <<.
#!/bin/bash
set -e

/usr/sbin/update-rc.d a3s remove

exit 0
 
.
chmod +x debian/DEBIAN/prerm

cp -R etc debian/

fakeroot dpkg -b debian/ ./a3s-${VERSION}-all.deb

rm -Rf debian

