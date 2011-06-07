# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit ni-driver

DESCRIPTION="National Instruments NI-PAL service manager"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/5.0/linux/NI-VISA-5.0.0.iso"

KEYWORDS="-* ~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/ni-kal"
DEPEND="${RDEPEND}"

QA_PRESTRIPPED="/usr/sbin/nipalsm /opt/natinst/nipal/sbin/nipalsm"

src_unpack() {
	NI_RPMFILES=( "nipali*.rpm" )
	use amd64 && NI_RPMFILES=( ${NI_RPMFILES[@]-} "nipalki*.x86_64.rpm" )
	use x86 && NI_RPMFILES=( ${NI_RPMFILES[@]-} "nipalki*.i386.rpm" )

	ni-driver_src_unpack
}

src_install() {
	# main installation
	dodir ${NI_PREFIX}/natinst
	cp -a "${S}"/usr/local/natinst/* "${D}${NI_PREFIX}"/natinst/ || die

	# register configuration directory
	dodir /etc/natinst
	dosym ${NI_PREFIX}/natinst/nipal/etc /etc/natinst/nipal
	echo "${NI_PREFIX}/natinst/nipal" > "${D}${NI_PREFIX}"/natinst/nipal/etc/nipal.dir

	# shared libraries
	dolib.so "${S}"/usr/local/natinst/nipal/lib/libnipalu.so.*

	# service manager
	dosbin "${S}"/usr/local/natinst/nipal/sbin/nipalsm

	# the runlevel scripts
	doinitd "${S}"/usr/local/natinst/nipal/etc/init.d/nipal
	newinitd "${FILESDIR}/${P}"-nipalwrapper nipalwrapper

	dodir /var/lib/natinst/nipal
	dodir /var/lock/subsys

	dodir ${NI_PREFIX}/natinst/nikal/etc/clientkdb/nipal
	dosym ${NI_PREFIX}/natinst/nipal/src/objects/nipalk-unversioned.o ${NI_PREFIX}/natinst/nikal/etc/clientkdb/nipal/

	newenvd "${FILESDIR}/ni-pal-${PV}-envd" 81nipal

	# We create the NI share directory already here since it is (ahem...) shared 
	# between different packages using ni-pal. It contains only etc/share.dir though...
	#
	dodir $(get-nisharedir)/etc
	echo "$(get-nisharedir)" > "${D}$(get-nisharedir)"/etc/share.dir
	dosym $(get-nisharedir)/etc /etc/natinst/share

	dodir $(get-nisharedir)/errors/English
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/English/nipal-errors.txt $(get-nisharedir)/errors/English

	dodir $(get-nisharedir)/errors/French
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/French/nipal-errors.txt  $(get-nisharedir)/errors/French
	dodir $(get-nisharedir)/errors/German
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/German/nipal-errors.txt  $(get-nisharedir)/errors/German
	dodir $(get-nisharedir)/errors/Japanese
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/Japanese/nipal-errors.txt $(get-nisharedir)/errors/Japanese
	dodir $(get-nisharedir)/errors/Korean
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/Korean/nipal-errors.txt $(get-nisharedir)/errors/Korean
}

pkg_postinst() {
	ni-driver_pkg_postinst

	elog "Running updateNIDrivers."
	echo
	${NI_PREFIX}/natinst/nikal/bin/updateNIDrivers

	echo
	echo
	elog "You should start /etc/init.d/nipalwrapper and/or add it to your default runlevel."
}
