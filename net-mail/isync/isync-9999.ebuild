# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/isync/isync-1.0.6.ebuild,v 1.3 2013/02/24 11:25:37 ago Exp $

EAPI=5

DESCRIPTION="MailDir mailbox synchronizer"
HOMEPAGE="http://isync.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == 9999 ]]; then 
  EGIT_REPO_URI="git://isync.git.sourceforge.net/gitroot/isync/isync"
  GIT_ECLASS="git-2 autotools"
  KEYWORDS=""
else
  SRC_URI="mirror://sourceforge/isync/${P}.tar.gz"
  KEYWORDS="~amd64 ~ppc ~x86"
fi

inherit eutils ${GIT_ECLASS}

IUSE="ssl"

RDEPEND=">=sys-libs/db-4.2
	ssl? ( >=dev-libs/openssl-0.9.6 )"
DEPEND="dev-perl/TimeDate
	${RDEPEND}"

src_prepare () {
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure () {
	econf $(use_with ssl)
}

src_install()
{
	emake DESTDIR="${D}" install
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die
}
