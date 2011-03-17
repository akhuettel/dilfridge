# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2

inherit python

MY_PN="Impressive"

DESCRIPTION="Stylish way of giving presentations with Python"
HOMEPAGE="http://impressive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-text/pdftk
	dev-python/imaging
	dev-python/pygame
	dev-python/pyopengl
	x11-misc/xdg-utils
	x11-apps/xrandr
	|| ( app-text/xpdf app-text/ghostscript-gpl )
	|| ( media-fonts/dejavu media-fonts/ttf-bitstream-vera media-fonts/corefonts )"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	python_convert_shebangs 2 impressive.py
	dobin impressive.py || die
	doman impressive.1 || die
	dohtml impressive.html || die
	dodoc changelog.txt demo.pdf || die
}
