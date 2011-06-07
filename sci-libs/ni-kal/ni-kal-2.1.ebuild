# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base linux-info linux-mod ni-driver

DESCRIPTION="NI-KAL National Instruments kernel abstraction layer"
SRC_URI="http://ftp.ni.com/support/softlib/kal/2.1/NIKAL21.iso"

KEYWORDS=""
SLOT="0"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-ioctl.patch" )

pkg_setup() {
	ni-driver_pkg_setup

	# this checks if the kernel is configured and does some other magic
	linux-mod_pkg_setup
}

src_configure() {
	cd "${S}/usr/local/natinst/nikal/src/nikal/"

	# necessary to use linux-mod_src_compile
	MODULE_NAMES="nikal(natinst/nikal:${S}/usr/local/natinst/nikal/src/nikal:${S}/usr/local/natinst/nikal/src/nikal)"
	BUILD_TARGETS="all"
	BUILD_TARGET_ARCH="${ARCH}"

	./configure || die "ni-kal configure script failed"
}

src_compile() {
	cd "${S}/usr/local/natinst/nikal/src/nikal/"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodir "${NI_PREFIX}"
	cp -a "${S}/usr/local/natinst" "${D}${NI_PREFIX}/natinst"

	dodir "${NI_PREFIX}/natinst/nikal/etc/clientkdb"

	dodir /etc/natinst
	dosym "${NI_PREFIX}/natinst/nikal/etc" /etc/natinst/nikal

	echo "${NI_PREFIX}/natinst/nikal" > "${D}${NI_PREFIX}/natinst/nikal/etc/nikal.dir"

	dosym "${NI_PREFIX}/natinst/nikal/bin/updateNIDrivers" /usr/bin/
	dosym "${NI_PREFIX}/natinst/nikal/bin/niSystemReport" /usr/bin/

	ewarn "If you have 4GB of memory or more, pass \"mem=4096M\" as an kernel option to avoid segfaults!"
}
