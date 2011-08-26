# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://gitorious.org/lab-measurement/lab.git"
EGIT_BRANCH="connections"
EGIT_SOURCEDIR=${S}
inherit perl-module git-2

DESCRIPTION="Front-end instrument modules for the Lab::Measurement module stack"
HOMEPAGE="http://www.labmeasurement.de/"

# this is perl's license, whatever it means
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/Exception-Class
	virtual/perl-Time-HiRes
	dev-perl/TermReadKey
	dev-perl/XML-Generator
	dev-perl/XML-DOM
	dev-perl/XML-Twig
	dev-perl/encoding-warnings
	perl-core/Switch
	sci-visualization/gnuplot
	!dev-perl/Lab-Instrument
	!dev-perl/Lab-Tools
"
DEPEND="
	${RDEPEND}
	virtual/perl-Module-Build
"

S=${WORKDIR}/${P}/Measurement

pkg_postinst() {
	elog "You may want to install one or more backend driver modules. Supported are"
	elog "    sci-libs/linuxgpib    Open-source GPIB hardware driver"
	elog "    dev-perl/Lab-VISA     Bindings for the NI proprietary VISA driver"
	elog "                          stack (dilfridge overlay)"
}
