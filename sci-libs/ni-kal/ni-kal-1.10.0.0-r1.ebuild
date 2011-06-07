# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils linux-info linux-mod ni-driver

MY_PDIR=$(get_version_component_range 1-2)
MY_DISTFILE="NIKAL$(get_version_component_range 1)$(get_version_component_range 2).iso"

DESCRIPTION="NI-KAL National Instruments kernel abstraction layer"
SRC_URI="http://ftp.ni.com/support/softlib/kal/${MY_PDIR}/${MY_DISTFILE}"

KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="bindist mirror primaryuri"

pkg_setup() {
	if kernel_is lt 2 4; then
		die "${P} needs a kernel >=2.4! Please set your KERNEL_DIR or /usr/src/linux suitably"
	fi

	if kernel_is gt 2 6 24; then
		if ! linux_chkconfig_present UNUSED_SYMBOLS; then
			eerror
			eerror "NI-KAL needs to link to the kernel symbol init_mm. Starting from kernel"
			eerror "version 2.6.25, this symbol is only exported with the configuration "
			eerror "option CONFIG_UNUSED_SYMBOLS set (if at all). Please re-compile your"
			eerror "kernel if possible and retry."
			die "Compiling nikal.ko kernel module not possible."
		fi
	fi

	if kernel_is gt 2 6 28; then
		eerror
		eerror "NI-KAL needs to link to the kernel symbol init_mm. The export of this symbol"
		eerror "has been removed on the x86 architecture in kernel version 2.6.29."
		die "Compiling nikal.ko kernel module not possible."
	fi

	# this checks if the kernel is configured and does some other magic
	linux-mod_pkg_setup
}

src_compile() {
	cd "${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src"

	# necessary to use linux-mod_src_compile
	MODULE_NAMES="nikal(natinst/nikal:${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src:${S}/${NI_RPMDIRS[0]}/usr/local/natinst/nikal/src/objects)"
	BUILD_TARGETS="all"
	BUILD_TARGET_ARCH="${ARCH}"

	./configure || die "ni-kal configure script failed"
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
