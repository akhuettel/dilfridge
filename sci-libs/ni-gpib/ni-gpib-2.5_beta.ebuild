# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils linux-info linux-mod


DESCRIPTION="NI GPIB 488.2 driver"
SRC_URI="http://ftp.ni.com/support/softlib/gpib/linux/Linux%20Beta/ni4882-2.5.4b1-release.tar.gz"

HOMEPAGE="http://www.ni.com/"
RESTRICT="primaryuri"

KEYWORDS=""
SLOT="0"
LICENSE="ni-visa"
IUSE=""

# run time dependencies
RDEPEND=">=sci-misc/ni-pal-2.3.0 >=sci-misc/ni-kal-1.8.0 >=sci-libs/labview-runtime-8.2.1"
# we'll ignore rpm-dependency on ni-spy for now, this has to be tested since I don't think it's necessary!

# build time dependencies
DEPEND="${RDEPEND} app-arch/rpm2targz"


# seems that NI lets us directly download the file, so we dont need fetch restriction. 
# before the e-build gets published in any way this has obviously to be OK'ed from NI. 
# RESTRICT="fetch"

XXX_LIBS="/usr/local/lib"
XXX_INSTDIR="/usr/local"

XXX_TAR_FILE="ni4882-2.5.4b1-release.tar.gz"
XXX_TAR_DIR="release"
XXX_INNER_TAR="NI4882-2.5.4b1.tar.gz"
XXX_RPM_FILE="ni4882i-2.5.4-b1.i386.rpm"
XXX_RPM_AS_TAR="ni4882i-2.5.4-b1.i386.tar.gz"

if use x86; then
  XXX_RPM_FILE_K="ni4882ki-2.5.4-b1.i386.rpm"
  XXX_RPM_AS_TAR_K="ni4882ki-2.5.4-b1.i386.tar.gz"
elif use amd64; then
  XXX_RPM_FILE_K="ni4882ki-2.5.4-b1.x86_64.rpm"
  XXX_RPM_AS_TAR_K="ni4882ki-2.5.4-b1.x86_64.tar.gz"
fi

pkg_setup() {
        if kernel_is lt 2 4; then
                die "${P} needs a kernel >=2.4! Please set your KERNEL_DIR or /usr/src/linux suitably"
        fi
}


src_unpack() {

	cd ${WORKDIR}

     	tar -x -v -z -f ${DISTDIR}/$XXX_TAR_FILE
	mv $XXX_TAR_DIR ${S}

	mkdir ${S}/innertar
	cd ${S}/innertar
	tar -x -v -z -f ${S}/$XXX_INNER_TAR
  	
      	mkdir ${S}/ni4882i
      	mkdir ${S}/ni4882ki

    	cd ${S}/ni4882i
	rpm2targz ${S}/innertar/rpms/${XXX_RPM_FILE}
        tar -xzvf ${XXX_RPM_AS_TAR} --no-same-owner

    	cd ${S}/ni4882ki
	rpm2targz ${S}/innertar/rpms/${XXX_RPM_FILE_K}
        tar -xzvf ${XXX_RPM_AS_TAR_K} --no-same-owner

} 

src_compile() {

	einfo Nothing to compile here...

}

src_install() {

	dodir ${XXX_INSTDIR}
	cp -a ${S}/ni4882ki/usr/local/natinst ${D}${XXX_INSTDIR}/
	cp -a ${S}/ni4882i/usr/local/natinst ${D}${XXX_INSTDIR}/

   	echo "${XXX_INSTDIR}/natinst/ni4882" > ${D}${XXX_INSTDIR}/natinst/ni4882/etc/ni4882.dir
 	dodir /etc/natinst
	dosym ${XXX_INSTDIR}/natinst/ni4882/etc /etc/natinst/ni4882

	dodir /var/lock/subsys

	dodir ${XXX_INSTDIR}/natinst/share/errors/English
	dosym ${XXX_INSTDIR}/natinst/ni4882/etc/errors/English/NI-488-errors.txt ${XXX_INSTDIR}/natinst/share/errors/English/

	dodir ${XXX_INSTDIR}/natinst/include
	dosym ${XXX_INSTDIR}/natinst/ni4882/include/ni488.h ${XXX_INSTDIR}/natinst/include/ni488.h

	dodir ${XXX_LIBS}
	
	dosym ${XXX_INSTDIR}/natinst/ni4882/lib/libgpibapi.so.2.5.4 ${XXX_LIBS}/
	dosym ${XXX_INSTDIR}/natinst/ni4882/lib/libni488config.so.2.5.4 ${XXX_LIBS}/
	dosym ${XXX_INSTDIR}/natinst/ni4882/lib/libgpibconf.so.2.5.4 ${XXX_LIBS}/
	dosym ${XXX_INSTDIR}/natinst/ni4882/lib/liblvgpibconf.so.2.5.4 ${XXX_LIBS}/
	dosym ${XXX_LIBS}/libgpibapi.so.2.5.4 ${XXX_LIBS}/libgpibapi.so.2
	dosym ${XXX_LIBS}/libgpibapi.so.2 ${XXX_LIBS}/libgpibapi.so
	dosym ${XXX_LIBS}/libni488config.so.2.5.4 ${XXX_LIBS}/libni488config.so.2
	dosym ${XXX_LIBS}/libni488config.so.2 ${XXX_LIBS}/libni488config.so
	dosym ${XXX_LIBS}/libgpibconf.so.2.5.4 ${XXX_LIBS}/libgpibconf.so.2
	dosym ${XXX_LIBS}/libgpibconf.so.2 ${XXX_LIBS}/libgpibconf.so
	dosym ${XXX_LIBS}/liblvgpibconf.so.2.5.4 ${XXX_LIBS}/liblvgpibconf.so.2
	dosym ${XXX_LIBS}/liblvgpibconf.so.2 ${XXX_LIBS}/liblvgpibconf.so


#	cp ${D}${XXX_INSTDIR}/natinst/ni4882/lib/libgpibapi.so.2.5.4 ${D}${XXX_LIBS}/
#	cp ${D}${XXX_INSTDIR}/natinst/ni4882/lib/libni488config.so.2.5.4 ${D}${XXX_LIBS}/
#	cp ${D}${XXX_INSTDIR}/natinst/ni4882/lib/libgpibconf.so.2.5.4 ${D}${XXX_LIBS}/
#	cp ${D}${XXX_INSTDIR}/natinst/ni4882/lib/liblvgpibconf.so.2.5.4 ${D}${XXX_LIBS}/

	dodir ${XXX_INSTDIR}/natinst/bin
	dosym ${XXX_INSTDIR}/natinst/ni4882/bin/gpibintctrl ${XXX_INSTDIR}/natinst/bin
	dosym ${XXX_INSTDIR}/natinst/ni4882/bin/gpibexplorer ${XXX_INSTDIR}/natinst/bin
	dosym ${XXX_INSTDIR}/natinst/ni4882/bin/gpibtsw ${XXX_INSTDIR}/natinst/bin

	dodir /usr/local/bin
	cp ${D}${XXX_INSTDIR}/natinst/ni4882/bin/gpibintctrl ${D}/usr/local/bin/
	cp ${D}${XXX_INSTDIR}/natinst/ni4882/bin/gpibexplorer ${D}/usr/local/bin/
	cp ${D}${XXX_INSTDIR}/natinst/ni4882/bin/gpibtsw ${D}/usr/local/bin/

	# Ensure correct permissions for binaries and libraries

	chmod 0755 ${D}${XXX_INSTDIR}/natinst/ni4882/bin/*
	chmod 0755 ${D}${XXX_INSTDIR}/natinst/ni4882/lib/*.so*
	chmod 0644 ${D}${XXX_INSTDIR}/natinst/ni4882/lib/*.o
	chmod 0644 ${D}${XXX_INSTDIR}/natinst/ni4882/src/objects/*.o

	# Dynamically modify our Spy API linkage file to contain
	# the correct path to our help files so that Spy function
	# help will work
	chmod +w ${D}${XXX_INSTDIR}/natinst/ni4882/etc/nispy/APIs/1
	echo "WinHelp = \"${XXX_INSTDIR}/natinst/ni4882/docs/OnlineHelp/GpibHelp/ni4882linux.chm\"" >> ${D}${XXX_INSTDIR}/natinst/ni4882/etc/nispy/APIs/1
	chmod -w ${D}${XXX_INSTDIR}/natinst/ni4882/etc/nispy/APIs/1

	# Create a symlink to our Spy API linkage file
	# so that Spy knows what to do with GPIB calls it receives
	dodir ${XXX_INSTDIR}/natinst/share/nispy/APIs
	dosym ${XXX_INSTDIR}/natinst/ni4882/etc/nispy/APIs/1 ${XXX_INSTDIR}/natinst/share/nispy/APIs/
 

	# Now we still have to implement some stuff from the installer script INSIDE the RPM. 
	# Box in a box in a box in a box...

	# The nipal module manager generates for userspace daemons just an init script
	# (fitting for SuSE etc) and places it in the runlevels. 

	# We don't do this here but provide the script via the FILESDIR, and include NI's wrapper for gentoo
	# (this is necessary for gpibtsw to work)

	dodir ${XXX_INSTDIR}/natinst/nipal/etc/init.d
	cp -a ${FILESDIR}/${P}-gpibenumsvc  ${D}${XXX_INSTDIR}/natinst/nipal/etc/init.d/gpibenumsvc
	dodir /etc/init.d
	dosym ${XXX_INSTDIR}/natinst/nipal/etc/init.d/gpibenumsvc /etc/init.d/gpibenumsvc

	newinitd ${FILESDIR}/${P}-gpibenumsvcwrapper gpibenumsvcwrapper

	# the kernel driver is done with our ni-pal initscript mechanism. we just have to 
	# add it to the ni-KAL client database correctly...
	dodir /etc/natinst/nikal/clientkdb/ni4882
	dosym ${XXX_INSTDIR}/natinst/ni4882/src/objects/ni488k-unversioned.o /etc/natinst/nikal/clientkdb/ni4882/
	dosym ${XXX_INSTDIR}/natinst/ni4882/src/objects/ni488lock-unversioned.o /etc/natinst/nikal/clientkdb/ni4882/

	dodir ${XXX_INSTDIR}/natinst/nipal/etc/inf
	dosym ${XXX_INSTDIR}/natinst/ni4882/etc/ni488.inf ${XXX_INSTDIR}/natinst/nipal/etc/inf/ni488.inf

	# this is needed for the runlevel script
	dodir /etc/natinst/nipal/services
	dosym ${XXX_INSTDIR}/natinst/ni4882/lib/libgpibenumsvc.so.2.5.4 /etc/natinst/nipal/services/
}

pkg_postinst() {
	ewarn "You need to run ${XXX_INSTDIR}/natinst/nikal/bin/updateNIDrivers and restart /etc/init.d/nipal after this."
	ewarn "You should start /etc/init.d/gpibenumsvc now and/or add it to your default runlevel."
}






