# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/hdaps_monitor/hdaps_monitor-0.3.ebuild,v 1.3 2011/10/29 00:41:28 abcd Exp $

EAPI=4
inherit subversion kde4-base

MY_PN=LabPlot
MY_P=${MY_PN}-${PV}

DESCRIPTION="KDE data analysis and visualisation program"
HOMEPAGE="http://labplot.sourceforge.net/"

# SRC_URI="http://prdownloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
ESVN_REPO_URI="https://labplot.svn.sourceforge.net/svnroot/labplot/2.0/"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-libs/cdf
	sci-libs/gsl
	sci-libs/hdf5
	sci-libs/liborigin
	sci-libs/netcdf
"
RDEPEND="$DEPEND"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${P}-liborigin2.patch" )

# this is partly hardwired in the build system :(
CMAKE_BUILD_DIR=${S}/build
