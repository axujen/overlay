# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
#RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"
inherit python

DESCRIPTION="A Python Imaging Library"
HOMEPAGE="http://www.pythonware.com/products/pil"
#SRC_URI="http://effbot.org/media/downloads/${MY_P}-${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="http://effbot.org/downloads/Imaging-${PV}.tar.gz"

KEYWORDS="~amd64"
IUSE="doc ext sane examples"
LICENSE="MIT"
SLOT="0"
PYTHON_MODNAME="${MY_P}"

RDEPEND=">=media-libs/jpeg-6a
	>=media-libs/freetype-2.3.9
	>=media-libs/lcms-1.1.5"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S=${WORKDIR}/${P/pil/PIL}

src_compile() {
	do_build() {
		if use ext; then
			"$(PYTHON)" setup.py build_ext -i
		fi

		if use sane; then
			pushd Sane > /dev/null
			PYTHONPATH=. "$(PYTHON)" setup.py build
			popd > /dev/null
		fi
		"$(PYTHON)" setup.py build
	}
	python_execute_function do_build
}

src_test() {
	testing() {
		PYTHONPATH="${S}"/ "$(PYTHON)" selftest.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	do_sane() {
		insinto $(python_get_sitedir)/PIL/
		doins $(find Sane -name _sane.so)
		doins $(find Sane -name sane.py)
		chmod +x "${ED}"$(python_get_sitedir)/PIL/_sane.so || die
	}
	use sane && python_execute_function do_sane
	use doc && dohtml Docs/*
	if use examples; then
		insinto use/share/doc/${P}/demo
		doins Sane/demo*.py
	fi
}
