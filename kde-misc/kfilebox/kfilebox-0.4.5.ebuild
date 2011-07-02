# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS="ar br cs de es fr gl it lt nl pl pt ru si tr zh zh_CN"
inherit qt4-r2

DESCRIPTION="KDE dropbox client"
HOMEPAGE="http://kdropbox.deuteros.es/"
SRC_URI="mirror://sourceforge/kdropbox/${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

for name in ${LANGS} ; do IUSE+="linguas_$name " ; done
unset name

DEPEND="kde-base/kdelibs"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-installroot.patch" )

src_install() {
	dobin bin/kfilebox
	MAKEOPTS="${MAKEOPTS} -j1" qt4-r2_src_install

	for lang in ${LANGS}; do
		if ! hasq ${lang} ${LINGUAS}; then
			rm -rf "${D}"/usr/share/locale/${lang} || die
		fi
	done
}