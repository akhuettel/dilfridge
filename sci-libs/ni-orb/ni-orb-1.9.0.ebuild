# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils linux-info

DESCRIPTION="NI Object Request Broker"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/4.4/linux/NI-VISA-4.4.0.iso"
HOMEPAGE="http://www.ni.com/"

KEYWORDS=""
SLOT="0"
LICENSE="ni-visa"
IUSE=""

# run time dependencies
RDEPEND=">=sci-misc/ni-rpc-4.0.0"

# build time dependencies
DEPEND="${RDEPEND} >=app-cdr/poweriso-1.2-r1 app-arch/rpm2targz"

RESTRICT="bindist mirror primaryuri"

XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"

XXX_RPM="niorbi-1.9.0-f0.i386.rpm"
XXX_AS_TAR="niorbi-1.9.0-f0.i386.tar.gz"


pkg_setup() {
        if kernel_is lt 2 4; then
                die "${P} needs a kernel >=2.4! Please set your KERNEL_DIR or /usr/src/linux suitably"
        fi
}


src_unpack() {

      mkdir -p ${S}/cdimage
      poweriso extract ${DISTDIR}/NI-VISA-4.4.0.iso / -od ${S}/cdimage

      mkdir ${S}/tar
      tar -C ${S}/tar -x -v -z -f ${S}/cdimage/NICVISA_.TZ

      mkdir ${S}/niorb
      cd ${S}/niorb
      rpm2targz ${S}/tar/niorb/${XXX_RPM}
      tar -xzvf ${XXX_AS_TAR} --no-same-owner


} 


src_install() {

	rm ${S}/niorb/usr/local/natinst/.nicore/etc/nicore.dir		# this is already installed by ni-rpc
       	dodir ${XXX_INSTDIR}/natinst
       	cp -a -v ${S}/niorb/usr/local/natinst/.nicore ${D}${XXX_INSTDIR}/natinst/.nicore

	dodir /etc/natinst
        dosym ${XXX_INSTDIR}/natinst/.nicore/etc /etc/natinst/.nicore

	dodir ${XXX_INSTDIR}/natinst/share/errors/English/
	dosym ${XXX_INSTDIR}/natinst/.nicore/etc/errors/English/niorb-errors.txt ${XXX_INSTDIR}/natinst/share/errors/English/
	dodir ${XXX_INSTDIR}/natinst/share/errors/French/
	dosym ${XXX_INSTDIR}/natinst/.nicore/etc/errors/French/niorb-errors.txt ${XXX_INSTDIR}/natinst/share/errors/French/
	dodir ${XXX_INSTDIR}/natinst/share/errors/German/
	dosym ${XXX_INSTDIR}/natinst/.nicore/etc/errors/German/niorb-errors.txt ${XXX_INSTDIR}/natinst/share/errors/German/
	dodir ${XXX_INSTDIR}/natinst/share/errors/Japanese/
	dosym ${XXX_INSTDIR}/natinst/.nicore/etc/errors/Japanese/niorb-errors.txt ${XXX_INSTDIR}/natinst/share/errors/Japanese/
	dodir ${XXX_INSTDIR}/natinst/share/errors/Korean/
	dosym ${XXX_INSTDIR}/natinst/.nicore/etc/errors/Korean/niorb-errors.txt ${XXX_INSTDIR}/natinst/share/errors/Korean/

        dodir ${XXX_LIBS}
        dosym ${XXX_INSTDIR}/natinst/.nicore/lib/libniorbu.so.1.9.0 ${XXX_LIBS}/
        dosym ${XXX_LIBS}/libniorbu.so.1.9.0 ${XXX_LIBS}/libniorbu.so.1
        dosym ${XXX_LIBS}/libniorbu.so.1 ${XXX_LIBS}/libniorbu.so


	# is this path correct? just guessing...
        dosym ${XXX_INSTDIR}/natinst/.nicore/src/objects/niorbk-unversioned.o /etc/natinst/nikal/clientkdb/.nicore/
}

pkg_postinst() {

        ewarn "You should run"
        ewarn "/usr/local/natinst/.nicore/bin/orbClassMapSilent /file /usr/local/natinst/.nicore/etc/niorbAdd.ocm"
        ewarn "and see what it does..."
 
}






