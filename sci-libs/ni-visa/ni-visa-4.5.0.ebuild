# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils linux-info

short_PV="4.5"

DESCRIPTION="NI VISA library"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/$short_PV/Linux/NI-VISA-$PV.iso"
HOMEPAGE="http://www.ni.com/"
KEYWORDS=""
SLOT="0"
LICENSE="ni-visa"
RESTRICT="bindist mirror primaryuri"

IUSE=""

# run time dependencies
RDEPEND=">=sci-misc/ni-pal-1.10.2 sys-fs/udev"

# build time dependencies
DEPEND="${RDEPEND} >=app-cdr/poweriso-1.2-r1 app-arch/rpm2targz"


# seems that NI lets us directly download the file, so we dont need fetch restriction. 
# before the e-build gets published in any way this has obviously to be OK'ed from NI. 
# RESTRICT="fetch"

XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"

XXX_RPM_FILE_NIVISA="nivisa-$PV-f0.i386.rpm"
XXX_NIVISA_AS_TAR="nivisa-$PV-f0.i386.tar.gz"

#if use x86; then
  XXX_RPM_FILE_NIVISAK="nivisak-$PV-f0.i386.rpm"
  XXX_NIVISAK_AS_TAR="nivisak-$PV-f0.i386.tar.gz"
#elif use amd64; then
#  XXX_RPM_FILE_NIVISAK="nivisak-$PV-f0.x86_64.rpm"
#  XXX_NIVISAK_AS_TAR="nivisak-$PV-f0.x86_64.tar.gz"
#fi

pkg_setup() {
        if kernel_is lt 2 4; then
                die "${P} needs a kernel >=2.4! Please set your KERNEL_DIR or /usr/src/linux suitably"
        fi
}


src_unpack() {

      mkdir -p ${S}/cdimage
      poweriso extract ${DISTDIR}/NI-VISA-$PV.iso / -od ${S}/cdimage

      mkdir ${S}/tar
      tar -C ${S}/tar -x -v -z -f ${S}/cdimage/nivisa-4.5.0f0.tar.gz

      mkdir ${S}/nivisa
      cd ${S}/nivisa
      rpm2targz ${S}/tar/rpms/${XXX_RPM_FILE_NIVISA}
      tar -xzvf ${XXX_NIVISA_AS_TAR} --no-same-owner


      cd ${S}
#      rpm -q --qf "%{PREIN}" -p ${S}/tar/nivisa/${XXX_RPM_FILE_NIVISA} > ${S}/nivisa-preinstall
#      rpm -q --qf "%{POSTIN}" -p ${S}/tar/nivisa/${XXX_RPM_FILE_NIVISA} > ${S}/nivisa-postinstall
	# 
	# This script contains a lot of functions to extract desktop entries, icons, start menu
	# etc. Not #1 priority right now, we'll do this later (maybe).
	# Good place to introduce kde and gnome useflags...
	#

      mkdir ${S}/nivisak
      cd ${S}/nivisak
      rpm2targz ${S}/tar/rpms/${XXX_RPM_FILE_NIVISAK}
      tar -xzvf ${XXX_NIVISAK_AS_TAR} --no-same-owner


} 


src_install() {

	dodir ${XXX_INSTDIR}/vxipnp
	cp -a ${S}/nivisa/usr/local/vxipnp/* ${D}${XXX_INSTDIR}/vxipnp
	cp -a ${S}/nivisak/usr/local/vxipnp/* ${D}${XXX_INSTDIR}/vxipnp

	dodir ${XXX_INSTDIR}/natinst/nikal/etc/clientkdb/vxipnp
	dosym  ${XXX_INSTDIR}/vxipnp/src/objects/NiViPciK-unversioned.o ${XXX_INSTDIR}/natinst/nikal/etc/clientkdb/vxipnp/
	dosym ${XXX_INSTDIR}/vxipnp/src/objects/NiViPxiK-unversioned.o ${XXX_INSTDIR}/natinst/nikal/etc/clientkdb/vxipnp/

	dodir ${XXX_LIBS}
	dodir ${XXX_INSTDIR}/natinst/bin
	dodir ${XXX_INSTDIR}/natinst/include

#   	ln -snf "${XXX_INSTDIR}/vxipnp/linux/bin/libvisa.so.7" ${D}${XXX_LIBS}/libvisa.so.7
#   	ln -snf "${XXX_INSTDIR}/vxipnp/linux/include/visa.h" ${D}${XXX_INSTDIR}/natinst/include/visa.h
#   	ln -snf "${XXX_INSTDIR}/vxipnp/linux/include/visatype.h" ${D}${XXX_INSTDIR}/natinst/include/visatype.h
#   	ln -snf "${XXX_INSTDIR}/vxipnp/linux/include/vpptype.h" ${D}${XXX_INSTDIR}/natinst/include/vpptype.h
#   	ln -snf "${XXX_INSTDIR}/vxipnp/linux/NIvisa/viclean" ${D}${XXX_INSTDIR}/natinst/bin/viclean

	cp ${D}${XXX_INSTDIR}/vxipnp/linux/bin/libvisa.so.7 ${D}${XXX_LIBS}/
   	cp ${D}${XXX_INSTDIR}/vxipnp/linux/include/visa.h ${D}${XXX_INSTDIR}/natinst/include/
   	cp ${D}${XXX_INSTDIR}/vxipnp/linux/include/visatype.h ${D}${XXX_INSTDIR}/natinst/include/
   	cp ${D}${XXX_INSTDIR}/vxipnp/linux/include/vpptype.h ${D}${XXX_INSTDIR}/natinst/include/
   	cp ${D}${XXX_INSTDIR}/vxipnp/linux/NIvisa/viclean ${D}${XXX_INSTDIR}/natinst/bin/


	dodir /etc/natinst
	dosym ${XXX_INSTDIR}/vxipnp/etc /etc/natinst/nivisa
	dosym ${XXX_INSTDIR}/vxipnp/etc /etc/natinst/vxipnp

	dodir ${XXX_INSTDIR}/natinst/share/etc

	echo "${XXX_INSTDIR}/vxipnp" > ${D}${XXX_INSTDIR}/vxipnp/etc/nivisa.dir
	echo "${XXX_INSTDIR}/vxipnp" > ${D}${XXX_INSTDIR}/vxipnp/etc/vxipnp.dir

	dodir ${XXX_INSTDIR}/natinst/share/NI-VISA
#	ln -snf "/${XXX_INSTDIR}/vxipnp/linux/NIvisa/.LabVIEW/libVisaCtrl.so" ${D}${XXX_INSTDIR}/natinst/share/NI-VISA/libVisaCtrl.so
	cp ${D}${XXX_INSTDIR}/vxipnp/linux/NIvisa/.LabVIEW/libVisaCtrl.so ${D}${XXX_INSTDIR}/natinst/share/NI-VISA/

	dodir ${XXX_INSTDIR}/natinst/share/nispy/APIs
	cp ${FILESDIR}/ni-visa-$PV-spyapifile ${D}${XXX_INSTDIR}/natinst/share/nispy/APIs/3

	dodir ${XXX_INSTDIR}/natinst/share/errors/English
	dosym ${XXX_INSTDIR}/vxipnp/etc/errors/English/VISA-errors.txt ${XXX_INSTDIR}/natinst/share/errors/English/
	dodir ${XXX_INSTDIR}/natinst/share/errors/French
	dosym ${XXX_INSTDIR}/vxipnp/etc/errors/French/VISA-errors.txt ${XXX_INSTDIR}/natinst/share/errors/French/
	dodir ${XXX_INSTDIR}/natinst/share/errors/German
	dosym ${XXX_INSTDIR}/vxipnp/etc/errors/German/VISA-errors.txt ${XXX_INSTDIR}/natinst/share/errors/German/
	dodir ${XXX_INSTDIR}/natinst/share/errors/Japanese
	dosym ${XXX_INSTDIR}/vxipnp/etc/errors/Japanese/VISA-errors.txt ${XXX_INSTDIR}/natinst/share/errors/Japanese/
	# Some day we'll do this with LINGUAS...

        dodir /etc/udev/agents.d/usb
        dodir  /etc/udev/rules.d
	ln -snf "${XXX_INSTDIR}/vxipnp/linux/NIvisa/USB/sys/nivisa_usbraw" ${D}/etc/udev/agents.d/usb/nivisa_usbraw
	ln -snf "${XXX_INSTDIR}/vxipnp/linux/NIvisa/USB/sys/nivisa_usbtmc" ${D}/etc/udev/agents.d/usb/nivisa_usbtmc
	ln -snf "${XXX_INSTDIR}/vxipnp/linux/NIvisa/USB/sys/nivisa_usbtmc.rules" ${D}/etc/udev/rules.d/91-nivisa_usbtmc.rules

}


pkg_postinst() {
        ewarn "You need to run ${XXX_INSTDIR}/natinst/nikal/bin/updateNIDrivers now."

	# maybe we should run it right here?
	# possible since SANDBOX is disabled in postinst
}
