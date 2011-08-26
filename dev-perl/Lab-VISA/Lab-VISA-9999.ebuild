# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module git-2

DESCRIPTION="Perl interface to National Instrument's VISA library"
HOMEPAGE="http://www.labvisa.de/"
EGIT_REPO_URI="git://gitorious.org/lab-measurement/lab.git"

# this is perl's license, whatever it means
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl sci-libs/ni-visa"
RDEPEND="${DEPEND}"

src_unpack() {
	git-2_src_unpack
	S=${WORKDIR}/${P}/VISA
}
