#!/bin/bash

mkdir -p debian/DEBIAN

BASE_VERSION="0.2"
VERSION="${BASE_VERSION}.`git rev-list HEAD --count`"

umask 0022

cp -R etc debian/

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

echo "changelog:"
cat debian/DEBIAN/changelog

read -s -t 10 -n 1 -p "To edit the changelog, Press any key within 10 seconds..."

if [ $? = 0 ] ; then
	echo -e "\n"
	read -s -n 1 -p "Edit ${PWD}/debian/DEBIAN/changelog and press any key when finished"
	echo -e "\n"
	
else
	echo "not editing"
fi
fi

git tag -a v${VERSION} -m "tag version ${VVERSION}"
git push origin v${VERSION}

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

cp scripts/postinst debian/DEBIAN/postinst

cat >debian/DEBIAN/prerm <<.
#!/bin/bash
set -e

/usr/sbin/update-rc.d a3s remove

exit 0
 
.
chmod +x debian/DEBIAN/prerm

fakeroot dpkg -b debian/ ./a3s-${VERSION}-all.deb

rm -Rf debian

