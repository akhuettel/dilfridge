# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit ni-driver

DESCRIPTION="NI LabVIEW runtime library"
SRC_URI="http://ftp.ni.com/support/softlib/visa/NI-VISA/5.0/linux/NI-VISA-5.0.0.iso"

KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

LABVIEW_DIR="/opt/LabVIEW-${PV}"

NI_RPMFILES=( "labview-*-rte-*.rpm" )

src_install() {
	cp -a ${S}/usr/local/lib/LabVIEW-2009/* ${D}${LABVIEW_DIR}/ || die
	cp -a ${S}/usr/local/lib/LabVIEW-2009/.data ${D}${LABVIEW_DIR}/ || die
	
	dodir "$(get-nisharedir)/Licenses"
	dodir "$(get-nisharedir)/errors/English"

	cp -f ${D}${LABVIEW_DIR}/.data/LV_RemotePanelConnection.lic ${D}/$(get-nisharedir)/Licenses/ || die

	cp -f ${S}/usr/local/lib/LabVIEW-2009/.data/VISA-errors.txt ${D}/usr/local/natinst/share/errors/English/VISA_errors.txt

	${S}/lvruntime/usr/local/lib/cp -f LabVIEW-8.2/.data/NI-488-errors.txt ${D}/$(get-nisharedir)/errors/English/
	
	echo "LDPATH=${LABVIEW_DIR}" > "${T}/97labviewrte"
	doenvd "${T}/97labviewrte"

#	dosym  ${XXX_LIBS}/LabVIEW-8.2/liblvrt.so.8.2.1 ${XXX_LIBS}/liblvrt.so.8.2
#	dosym  ${XXX_LIBS}/LabVIEW-8.2/liblvrtdark.so.8.2.1 ${XXX_LIBS}/liblvrtdark.so.8.2
#	# on my system, we need the following from this stuff:
#	dosym ${XXX_LIBS}/LabVIEW-8.2/patchlib/libGL.so.1.2 ${XXX_LIBS}/LabVIEW-8.2/patchlib/libGL.so.1
#	dosym ${XXX_LIBS}/LabVIEW-8.2/linux/libOSMesa.so.4 ${XXX_LIBS}/LabVIEW-8.2/patchlib/
}


