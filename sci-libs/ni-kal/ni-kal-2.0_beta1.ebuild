# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit versionator eutils linux-info linux-mod ni-driver

MY_PDIR=$(get_version_component_range 1-2)

DESCRIPTION="NI-KAL National Instruments kernel abstraction layer"
SRC_URI="http://ftp.ni.com/support/softlib/visa/VISA%20Run-Time%20Engine/5.0/linux/NI-VISA-Runtime-5.0.0.iso -> NI-VISA-Runtime-5.0.0-beta1.iso"

KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="bindist mirror primaryuri"

NI_RPMFILES="nivisa-runtime-5.0.0b5.tar.gz.dir/rpms/nikali-2.0.0-b1.noarch.rpm"

pkg_setup() {
	ni-driver_pkg_setup

	# this checks if the kernel is configured and does some other magic
	linux-mod_pkg_setup
}

src_prepare() {
	if kernel_is gt 2 6 32; then
		einfo Your kernel is 2.6.33 or newer. Patching header file locations.
		epatch "${FILESDIR}/kernel-checks.patch"
	fi
}

src_configure() {
	cd "${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src/nikal/"

	# necessary to use linux-mod_src_compile
	MODULE_NAMES="nikal(natinst/nikal:${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src/nikal:${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src/nikal)"
	BUILD_TARGETS="all"
	BUILD_TARGET_ARCH="${ARCH}"

	./configure || die "ni-kal configure script failed"
}

src_compile() {
	cd "${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src/nikal/"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	dodir "${NI_PREFIX}"
	cp -a "${S}/${NI_RPMDIRS[0]}/usr/local/natinst" "${D}${NI_PREFIX}/natinst"

	dodir "${NI_PREFIX}/natinst/nikal/etc/clientkdb"

	dodir /etc/natinst
	dosym "${NI_PREFIX}/natinst/nikal/etc" /etc/natinst/nikal

	echo "${NI_PREFIX}/natinst/nikal" > "${D}${NI_PREFIX}/natinst/nikal/etc/nikal.dir"

	dosym "${NI_PREFIX}/natinst/nikal/bin/updateNIDrivers" /usr/bin/
	dosym "${NI_PREFIX}/natinst/nikal/bin/niSystemReport" /usr/bin/

	ewarn "If you have 4GB of memory or more, pass \"mem=4096M\" as an kernel option to avoid segfaults!"
}
