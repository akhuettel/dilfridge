# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib ni-driver

DESCRIPTION="National Instruments NI-PAL service manager"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/4.5/Linux/NI-VISA-4.5.0.iso -> NI-VISA-Runtime-5.0.0-beta1.iso"

KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=">=sci-libs/ni-kal-1.10.0"
DEPEND="${RDEPEND}"

NI_RPMFILES="nivisa-runtime-5.0.0b5.tar.gz.dir/rpms/nipali-2.5.4-b2.i386.rpm"
use amd64 && NI_RPMFILES+=" nivisa-runtime-5.0.0b5.tar.gz.dir/rpms/nipalki-2.5.4-b2.x86_64.rpm"
use x86 && NI_RPMFILES+=" nivisa-runtime-5.0.0b5.tar.gz.dir/rpms/nipalki-2.5.4-b2.i386.rpm"

QA_PRESTRIPPED="/usr/sbin/nipalsm /opt/natinst/nipal/sbin/nipalsm"

RESTRICT="bindist mirror primaryuri"

src_install() {
	# now lets merge the rpm contents
	mkdir "${S}/merged"
	for rdir in ${NI_RPMDIRS}; do
		cp -a -i "${S}/$rdir"/* "${S}/merged/"
	done

	# main installation
	dodir ${NI_PREFIX}/natinst
	cp -a ${S}/merged/usr/local/natinst/* ${D}${NI_PREFIX}/natinst/

	# register configuration directory
	dodir /etc/natinst
	dosym ${NI_PREFIX}/natinst/nipal/etc /etc/natinst/nipal
        echo "${NI_PREFIX}/natinst/nipal" > ${D}${NI_PREFIX}/natinst/nipal/etc/nipal.dir

	# shared libraries
	dolib.so ${S}/merged/usr/local/natinst/nipal/lib/libnipalu.so.* 

	# service manager
	dosbin ${S}/merged/usr/local/natinst/nipal/sbin/nipalsm

	# the runlevel scripts
	doinitd ${S}/merged/usr/local/natinst/nipal/etc/init.d/nipal
	newinitd ${FILESDIR}/${P}-nipalwrapper nipalwrapper

	dodir /var/lib/natinst/nipal
	dodir /var/lock/subsys

	dodir ${NI_PREFIX}/natinst/nikal/etc/clientkdb/nipal
	dosym ${NI_PREFIX}/natinst/nipal/src/objects/nipalk-unversioned.o ${NI_PREFIX}/natinst/nikal/etc/clientkdb/nipal/

	newenvd ${FILESDIR}/ni-pal-$PV-envd 81nipal

	# We create the NI share directory already here since it is (ahem...) shared 
	# between different packages using ni-pal. It contains only etc/share.dir though...
	#
	dodir ${NI_PREFIX}/natinst/share/etc
	echo "${NI_PREFIX}/natinst/share" > ${D}${NI_PREFIX}/natinst/share/etc/share.dir
	dosym ${NI_PREFIX}/natinst/share/etc /etc/natinst/share

	dodir ${NI_PREFIX}/natinst/share/errors/English
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/English/nipal-errors.txt ${NI_PREFIX}/natinst/share/errors/English

	dodir ${NI_PREFIX}/natinst/share/errors/French
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/French/nipal-errors.txt  ${NI_PREFIX}/natinst/share/errors/French
	dodir ${NI_PREFIX}/natinst/share/errors/German
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/German/nipal-errors.txt  ${NI_PREFIX}/natinst/share/errors/German
	dodir ${NI_PREFIX}/natinst/share/errors/Japanese
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/Japanese/nipal-errors.txt ${NI_PREFIX}/natinst/share/errors/Japanese
	dodir ${NI_PREFIX}/natinst/share/errors/Korean
	dosym ${NI_PREFIX}/natinst/nipal/etc/errors/Korean/nipal-errors.txt   ${NI_PREFIX}/natinst/share/errors/Korean
}

pkg_postinst() {
	ni-driver_pkg_postinst

	elog "This is the moment when all drivers depending on ni-pal should be rebuilt. So, running updateNIDrivers now."
	${NI_PREFIX}/natinst/nikal/bin/updateNIDrivers

        elog "You should start /etc/init.d/nipalwrapper now and/or add it to your default runlevel."
}
