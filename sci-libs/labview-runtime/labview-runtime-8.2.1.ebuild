# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils linux-info


DESCRIPTION="LabVIEW runtime"

SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/4.4/linux/NI-VISA-4.4.0.iso"

HOMEPAGE="http://www.ni.com/"

KEYWORDS=""
RESTRICT="primaryuri"

SLOT="0"

LICENSE="ni-visa"

IUSE=""

# run time dependencies
RDEPEND=""

# build time dependencies
DEPEND="${RDEPEND} >=app-cdr/poweriso-1.2-r1 app-arch/rpm2targz"


XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"

XXX_RPM_FILE="labview82-rte-8.2.1-2.i386.rpm"
XXX_RPM_AS_TAR="labview82-rte-8.2.1-2.i386.tar.gz"

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

      mkdir ${S}/lvruntime
      cd ${S}/lvruntime

      rpm2targz ${S}/tar/lvruntime/${XXX_RPM_FILE}
      tar -xzvf ${XXX_RPM_AS_TAR} --no-same-owner


#      cd ${S}
#      rpm -q --qf "%{PREIN}" -p ${S}/tar/lvruntime/${XXX_RPM_FILE} > ${S}/preinstall
#      rpm -q --qf "%{POSTIN}" -p ${S}/tar/lvruntime/${XXX_RPM_FILE} > ${S}/postinstall

} 


src_install() {

	dodir ${XXX_LIBS}/LabVIEW-8.2
	cp -a ${S}/lvruntime/usr/local/lib/LabVIEW-8.2/* ${D}${XXX_LIBS}/LabVIEW-8.2
 
	dodir /usr/local/natinst/share/Licenses
	dodir /usr/local/natinst/share/errors/English

   	test -f /usr/local/natinst/share/Licenses/LV_RemotePanelConnection.lic ||
       		 cp -f ${S}/lvruntime/usr/local/lib/LabVIEW-8.2/.data/LV_RemotePanelConnection.lic ${D}/usr/local/natinst/share/Licenses/LV_RemotePanelConnection.lic

	test -f /usr/local/natinst/share/errors/English/VISA-errors.txt ||
      		cp -f ${S}/lvruntime/usr/local/lib/LabVIEW-8.2/.data/VISA-errors.txt ${D}/usr/local/natinst/share/errors/English/VISA_errors.txt

	test -f /usr/local/natinst/share/errors/English/NI-488-errors.txt ||
      		${S}/lvruntime/usr/local/lib/cp -f LabVIEW-8.2/.data/NI-488-errors.txt ${D}/usr/local/natinst/share/errors/English/NI-488-errors.txt

	dodir ${XXX_LIBS}

	dosym  ${XXX_LIBS}/LabVIEW-8.2/liblvrt.so.8.2.1 ${XXX_LIBS}/liblvrt.so.8.2
	dosym  ${XXX_LIBS}/LabVIEW-8.2/liblvrtdark.so.8.2.1 ${XXX_LIBS}/liblvrtdark.so.8.2

	#if [ -x /usr/bin/chcon ]; then # SELinux support
	#  /usr/bin/chcon -f -t textrel_shlib_t LabVIEW-8.2/liblvrt.so.8.2.1 >/dev/null 2>&1
	#  /usr/bin/chcon -f -t textrel_shlib_t LabVIEW-8.2/liblvrtdark.so.8.2.1 >/dev/null 2>&1
	#  /usr/bin/chcon -f -t textrel_shlib_t LabVIEW-8.2/linux/libOSMesa.so.4.0 >/dev/null 2>&1
	#fi


#	# Check for buggy NVidia libGL
#	ldd -r liblvrt.so.8.2 2>&1 | grep -q undefined
#	if [ $? -eq 0 ]; then
#	   cd LabVIEW-8.2/patchlib
#	   # If glapi symbols undefined, override system libGL put putting ours in search path
#	   rm -f libGL.so.1 libOSMesa.so.4
#	   ln -s libGL.so.1.2 libGL.so.1
#	   ldd -r ${LVRTDIR}/liblvrt.so.8.2 2>&1 | grep -q undefined
#	   test $? -eq 0 && ln -s ../linux/libOSMesa.so.4 libOSMesa.so.4
#	fi

# on my system, we need the following from this stuff:

	dosym ${XXX_LIBS}/LabVIEW-8.2/patchlib/libGL.so.1.2 ${XXX_LIBS}/LabVIEW-8.2/patchlib/libGL.so.1
	dosym ${XXX_LIBS}/LabVIEW-8.2/linux/libOSMesa.so.4 ${XXX_LIBS}/LabVIEW-8.2/patchlib/

}


