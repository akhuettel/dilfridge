# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/spyview/spyview-20100810.ebuild,v 1.5 2011/03/20 19:57:59 jlec Exp $

EAPI=4

inherit eutils

DEBFILE="rexjuniper_6.5R6.1_amd64.deb"

DESCRIPTION="Regensbug University Juniper VPN client"
HOMEPAGE="http://www.uni-regensburg.de/e/r/Benutzer/Speziell/Linux/Software/Softwareindex/01876_de.phtml"
SRC_URI="https://netstorage.uni-regensburg.de/oneNet/NetStorage/uni-soft/j/junipervpnclient/Download/${DEBFILE}"

LICENSE="internal-use-only"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=""
DEPEND="${COMMON_DEPEND}
	app-arch/deb2targz"
RDEPEND="${COMMON_DEPEND}"

RESTRICT="fetch bindist primaryuri mirror"

S=${WORKDIR}

src_unpack() {
	cd "${WORKDIR}" || die
	cp "${DISTDIR}/${DEBFILE}" . || die
	deb2targz "${DEBFILE}" || die
	tar xfvz "${DEBFILE/.deb/.tar.gz}" || die
}

src_prepare() {
	: ;
}

src_configure() {
	: ;
}

src_compile() {
	: ;
}

src_install() {
	domenu usr/local/share/applications/rexjnc_disconnect.desktop
	domenu usr/local/share/applications/rexjnc.desktop

	dobin usr/local/nc/rexjnc
	doicon usr/local/nc/vpn.png

	rm -r usr/local/share/applications usr/local/bin || die
	cp -a usr "${D}/" || die

	fperms u+s /usr/local/nc/ncsvc
}
