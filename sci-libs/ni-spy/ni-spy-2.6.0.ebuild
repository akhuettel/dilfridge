# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-info

DESCRIPTION="NI Spy"

SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/4.4/linux/NI-VISA-4.4.0.iso"
HOMEPAGE="http://www.ni.com/"

KEYWORDS=""
SLOT="0"
LICENSE="ni-visa"
IUSE=""

# run time dependencies
RDEPEND="sci-libs/labview-runtime"

# build time dependencies
DEPEND="${RDEPEND} >=app-cdr/poweriso-1.2-r1 app-arch/rpm2targz"

RESTRICT="bindist primaryuri mirror"

XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"

XXX_RPM_FILE="nispyi-2.6.0-f0.i386.rpm"
XXX_RPM_AS_TAR="nispyi-2.6.0-f0.i386.tar.gz"

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

      mkdir ${S}/nispy
      cd ${S}/nispy

      rpm2targz ${S}/tar/nispy/${XXX_RPM_FILE}
      tar -xzvf ${XXX_RPM_AS_TAR} --no-same-owner


      cd ${S}
      rpm -q --qf "%{PREIN}" -p ${S}/tar/nispy/${XXX_RPM_FILE} > ${S}/preinstall
      rpm -q --qf "%{POSTIN}" -p ${S}/tar/nispy/${XXX_RPM_FILE} > ${S}/postinstall

} 


src_install() {

	dodir ${XXX_INSTDIR}/natinst/nispy
	cp -a ${S}/nispy/usr/local/natinst/nispy/* ${D}${XXX_INSTDIR}/natinst/nispy/

	echo "${XXX_INSTDIR}/natinst/nispy" > ${D}${XXX_INSTDIR}/natinst/nispy/etc/nispy.dir
	dodir /etc/natinst
	dosym ${XXX_INSTDIR}/natinst/nispy/etc /etc/natinst/nispy

	dodir ${XXX_LIBS}
#	cp ${D}${XXX_INSTDIR}/natinst/nispy/lib/libNiSpyLog.so.2.6.0 ${D}${XXX_LIBS}/
	dosym ${XXX_INSTDIR}/natinst/nispy/lib/libNiSpyLog.so.2.6.0 ${XXX_LIBS}/
	dosym ${XXX_LIBS}/libNiSpyLog.so.2.6.0 ${XXX_LIBS}/libNiSpyLog.so.2
	dosym ${XXX_LIBS}/libNiSpyLog.so.2 ${XXX_LIBS}/libNiSpyLog.so

	dosym ${XXX_INSTDIR}/natinst/nispy/nispy /usr/local/bin/nispy

}


