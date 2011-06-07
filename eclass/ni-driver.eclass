# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

# @ECLASS: ni-driver.eclass
# @MAINTAINER:
# mail@akhuettel.de
# @BLURB: Class for handling National Instruments linux device driver packages.

inherit eutils rpm

HOMEPAGE="${HOMEPAGE:-http://www.ni.com/}"
RESTRICT="${RESTRICT:-bindist mirror primaryuri}"
LICENSE="${LICENSE:-ni-visa}"

DEPEND="app-cdr/poweriso"

NI_PREFIX="${NI_PREFIX:-/opt}"









# @FUNCTION: ni-driver_pkg_setup
# @USAGE: 
# @DESCRIPTION:
# pkg_setup phase, doing some preparation checks
ni-driver_pkg_setup() {

	# the NI drivers need at least kernel 2.4
	if kernel_is lt 2 4; then
		die "${P} needs a linux kernel >=2.4!"
	fi

	# we should check if some ni leftovers are lying around
	if [ -f /etc/natinst/nikal/etc/nikal.dir ]; then
		ONDISK=$(cat /etc/natinst/nikal/etc/nikal.dir)
		if [ x$ONDISK == x/opt/natinst/nikal ]; then
			einfo NI-KAL directory found at /opt/natinst/nikal, great.
		else
			die "Remainders of a non-portage NI driver installation found. This will never work. Aborting."
		fi
	fi
}








distiso_unpack() {
	local infile=${1}
	local outdir=$(basename ${infile}).dir

	einfo Extracting ${infile} to ${S}/${outdir}
	mkdir -p "${S}/${outdir}"
        poweriso extract "${DISTDIR}/${infile}" / -od "${S}/${outdir}"

	NI_DISTDIRS=( ${NI_DISTDIRS} "${outdir}" )
}

disttgz_unpack() {
	local infile=${1}
	local outdir=$(basename ${1}).dir

	einfo Extracting ${infile} to ${S}/${outdir}
	mkdir -p "${S}/${outdir}"
	cd "${S}/${outdir}"
        unpack "${DISTDIR}/${infile}"

	NI_DISTDIRS=( ${NI_DISTDIRS} "${outdir}" )
}







# @FUNCTION: ni-drivers_src_unpack
# @USAGE: <isofiles> <targzfiles>
# @DESCRIPTION:
# src_unpack phase, unpacking NI driver downloads (ISO=releases, tar.gz=betas)
ni-driver_src_unpack() {
	local a
	local dir

	# First, unpack the downloaded iso or tgz files. 
	for a in ${A} ; do
		case ${a} in
			*.iso) distiso_unpack "${a}" ;;
			*.tar.gz) disttgz_unpack "${a}" ;;
		esac
	done

	# Then, search for tar.gz files that were in there...
	if [ ${#NI_TARFILES[*]} -eq 0 ]; then 
		for a in ${NI_DISTDIRS} ; do 
			NI_TARFILES=$(find "${S}/${a}" -name "*.tar.gz"|sed -e "s#^${S}/##")
		done
	fi
	einfo ${#NI_TARFILES[*]} driver archive\(s\) found: ${NI_TARFILES[*]}

	# Then, unpack the tar.gz files...
	for a in ${NI_TARFILES} ; do 
		dir=$(basename $a).dir
		mkdir "${S}/${dir}"
		tar -x -z -C "${S}/${dir}" --no-same-owner -f "${S}/${a}"
		NI_TARDIRS=( ${NI_TARDIRS} "${dir}" )
	done
	
	# Then, search for the rpm files that were in there...
	if [ ${#NI_RPMFILES[*]} -eq 0 ]; then 
		for a in ${NI_TARDIRS} ; do 
			NI_RPMFILES=$(find "${S}/${a}" -name "*.rpm"|sed -e "s#^${S}/##")
		done
	fi
	einfo rpm file\(s\) for installation found: ${NI_RPMFILES[*]}

	# ... and unpack the rpm files.
	for a in ${NI_RPMFILES} ; do
		dir=$(basename $a).dir
		mkdir "${S}/${dir}"
		cd "${S}/${dir}"
		rpm_unpack ./../${a}
		NI_RPMDIRS=( ${NI_RPMDIRS} "${dir}" )
	done
}









# @FUNCTION: ni-driver_pkg_postinst
# @USAGE: 
# @DESCRIPTION:
# pkg_setup phase, doing some preparation checks
ni-driver_pkg_postinst() {
	elog
	elog Important - do not try to update this driver installation of ${PN} with the NI installer. 
	elog If you want to use the NI installer, first remove all related ebuilds!
	elog
}



EXPORT_FUNCTIONS pkg_setup src_unpack pkg_postinst