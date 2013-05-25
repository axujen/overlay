# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils
DESCRIPTION="portage package.* file manager."
HOMEPAGE="https://github.com/Pyntony/emod"
SRC_URI="https://github.com/Pyntony/${PN}/archive/${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd65 ~arm ~hppa ~mips ~ppc64 ~x86"
IUSE=""
RDEPEND=">=sys-apps/portage-2.3.0"

src_compile() {
	distutils_src_compile
}
src_install() {
	distutils_src_install
}
