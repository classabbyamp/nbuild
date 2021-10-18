#!/bin/sh
set -e
chroot-git clone /void-packages-origin /hostrepo
ln -s / /hostrepo/masterdir
cd /hostrepo
git fetch
git reset --hard "$GIT_REV"
cd -

cat <<! >/hostrepo/etc/conf
XBPS_CHROOT_CMD=ethereal
XBPS_ALLOW_CHROOT_BREAKOUT=yes
!

if [ "${HOST}" != "${TARGET}" ] ; then
        opts="-a ${TARGET}"
fi

/hostrepo/xbps-src "${opts}" "$NOMAD_META_PACKAGE" || curl -X POST "$CALLBACK_FAIL"

curl -X POST "$CALLBACK_DONE"
