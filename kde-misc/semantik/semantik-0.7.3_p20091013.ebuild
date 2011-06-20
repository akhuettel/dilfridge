# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit kde4-base waf-utils

DESCRIPTION="Mindmapping-like tool for document generation."
HOMEPAGE="http://freehackers.org/~tnagy/semantik.html"
SRC_URI="http://semantik.googlecode.com/files/semantik-snapshot.tar.bz2 -> ${P}.tar.bz2"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml
	dev-lang/python
"
RDEPEND="
	x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/qt-xmlpatterns
	dev-lang/python[xml]
"

S="${WORKDIR}/semantik-0.7.4"
WAF_BINARY="${S}/waf"

PATCHES=( "${FILESDIR}/${P}"-wscript_ldconfig.patch )

src_configure() {
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" "${WAF_BINARY}" \
		"--prefix=${EPREFIX}/usr" --want-rpath=0 \
		configure || die "configure failed"
}
