# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/rpm.eclass,v 1.20 2010/07/18 21:57:20 vapier Exp $

# @ECLASS: rpm.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: convenience class for extracting RPMs

inherit eutils

DEPEND=">=app-arch/rpm5offset-9.0"

# @FUNCTION: rpm_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified rpms like the unpack() function.
rpm5_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}
	local a rpmoff decompcmd
	for a in "$@" ; do
		echo ">>> Unpacking ${a} to ${PWD}"
		if [[ ${a} == ./* ]] ; then
			: nothing to do -- path is local
		elif [[ ${a} == ${DISTDIR}/* ]] ; then
			ewarn 'QA: do not use ${DISTDIR} with rpm_unpack -- it is added for you'
		elif [[ ${a} == /* ]] ; then
			ewarn 'QA: do not use full paths with rpm_unpack -- use ./ paths instead'
		else
			a="${DISTDIR}/${a}"
		fi
#		rpm2tar -O "${a}" | tar xf - || die "failure unpacking ${a}"
		rpmoff=`rpm5offset < ${a}`
		[ -z "${rpmoff}" ] && return 1

		decompcmd="lzma -dc"
		if [ -n "`dd if=${a} skip=${rpmoff} bs=1 count=3 2>/dev/null | file - | grep bzip2`" ]; then
			decompcmd="bzip2 -dc"
		fi
		if [ -n "`dd if=${a} skip=${rpmoff} bs=1 count=3 2>/dev/null | file - | grep gzip`" ]; then
			decompcmd="gzip -dc"
		fi

		dd ibs=${rpmoff} skip=1 if=${a} 2> /dev/null \
			| ${decompcmd} \
			| cpio -idmu --no-preserve-owner --quiet || return 1
	done
}

# @FUNCTION: srcrpm_unpack
# @USAGE: <rpms>
# @DESCRIPTION:
# Unpack the contents of the specified rpms like the unpack() function as well
# as any archives that it might contain.  Note that the secondary archive
# unpack isn't perfect in that it simply unpacks all archives in the working
# directory (with the assumption that there weren't any to start with).
srcrpm5_unpack() {
	[[ $# -eq 0 ]] && set -- ${A}
	rpm5_unpack "$@"

	# no .src.rpm files, then nothing to do
	[[ "$* " != *".src.rpm " ]] && return 0

	eshopts_push -s nullglob

	# unpack everything
	local a
	for a in *.tar.{gz,bz2} *.t{gz,bz2} *.zip *.ZIP ; do
		unpack "./${a}"
		rm -f "${a}"
	done

	eshopts_pop

	return 0
}

# @FUNCTION: rpm_src_unpack
# @DESCRIPTION:
# Automatically unpack all archives in ${A} including rpms.  If one of the
# archives in a source rpm, then the sub archives will be unpacked as well.
rpm5_src_unpack() {
	local a
	for a in ${A} ; do
		case ${a} in
		*.rpm) srcrpm5_unpack "${a}" ;;
		*)     unpack "${a}" ;;
		esac
	done
}

# @FUNCTION: rpm_spec_epatch
# @USAGE: [spec]
# @DESCRIPTION:
# Read the specified spec (defaults to ${PN}.spec) and attempt to apply
# all the patches listed in it.  If the spec does funky things like moving
# files around, well this won't handle that.
rpm5_spec_epatch() {
	local p spec=${1:-${PN}.spec}
	local dir=${spec%/*}
	grep '^%patch' "${spec}" | \
	while read line ; do
		set -- ${line}
		p=$1
		shift
		EPATCH_OPTS="$*"
		set -- $(grep "^P${p#%p}: " "${spec}")
		shift
		epatch "${dir:+${dir}/}$*"
	done
}

EXPORT_FUNCTIONS src_unpack