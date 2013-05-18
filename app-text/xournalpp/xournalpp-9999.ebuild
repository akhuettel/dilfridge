# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tmux/tmux-9999.ebuild,v 1.5 2011/07/30 11:58:51 grobian Exp $

EAPI=4

ESVN_REPO_URI="https://xournal.svn.sourceforge.net/svnroot/xournal/trunk/xournalpp"
ESVN_PROJECT="tmux"

inherit autotools subversion

DESCRIPTION="Application for notetaking, sketching, and keeping a journal using a stylus"
HOMEPAGE="http://xournal.sourceforge.net"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="python"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	eautoreconf
}
