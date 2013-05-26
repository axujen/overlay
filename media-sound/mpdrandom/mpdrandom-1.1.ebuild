# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2.7,3.2} )

inherit distutils
DESCRIPTION="A python script that adds the missing randomness to mpd's albums"
HOMEPAGE="https://github.com/axujen/mpdrandom"
SRC_URI="https://github.com/axujen/${PN}/archive/${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd65 ~arm ~hppa ~mips ~ppc64 ~x86"
IUSE=""
RDEPEND=">=dev-python/python-mpd-0.5.1"

src_compile() {
	distutils_src_compile
}
src_install() {
	distutils_src_install
}

