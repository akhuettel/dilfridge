# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info

DESCRIPTION="NI-RPC user library"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/4.4/linux/NI-VISA-4.4.0.iso"
HOMEPAGE="http://www.ni.com/"

KEYWORDS=""
SLOT="0"
LICENSE="ni-visa"
IUSE=""

# run time dependencies
RDEPEND=""

# build time dependencies
DEPEND="${RDEPEND} >=app-cdr/poweriso-1.2-r1 app-arch/rpm2targz"

RESTRICT="bindist mirror primaryuri"

XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"
 
XXX_RPM="nirpci-4.0.0-f1.i386.rpm"
XXX_AS_TAR="nirpci-4.0.0-f1.i386.tar.gz"


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

      mkdir ${S}/nirpc
      cd ${S}/nirpc
      rpm2targz ${S}/tar/nirpc/${XXX_RPM}
      tar -xzvf ${XXX_AS_TAR} --no-same-owner


} 


src_install() {

       	dodir ${XXX_INSTDIR}/natinst
       	cp -a -v ${S}/nirpc/usr/local/natinst/.nicore ${D}${XXX_INSTDIR}/natinst/.nicore

	dodir /etc/natinst
        dosym ${XXX_INSTDIR}/natinst/.nicore/etc /etc/natinst/.nicore

	echo "${XXX_INSTDIR}/natinst/.nicore" > ${D}${XXX_INSTDIR}/natinst/.nicore/etc/nicore.dir

        dodir ${XXX_LIBS}
        dosym ${XXX_INSTDIR}/natinst/.nicore/lib/libnirpc.so.4.0.0 ${XXX_LIBS}/
        dosym ${XXX_LIBS}/libnirpc.so.4.0.0 ${XXX_LIBS}/libnirpc.so.4
        dosym ${XXX_LIBS}/libnirpc.so.4 ${XXX_LIBS}/libnirpc.so
}






