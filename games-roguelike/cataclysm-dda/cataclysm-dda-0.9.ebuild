# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

# List "games" last, as suggested by the "Gentoo Games Ebuild HOWTO."
inherit games

# Fetch Github traballs.
DESCRIPTION="Roguelike set in a post-apocalyptic world"
HOMEPAGE="http://www.cataclysmdda.com"
SRC_URI="https://github.com/CleverRaven/Cataclysm-DDA/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tiles"

RDEPEND="
	sys-libs/ncurses:5=
	tiles? (
		media-libs/libsdl
		media-libs/sdl-ttf
		media-libs/sdl-image[jpeg,png]
		media-libs/freetype:2
	)

"

# Cataclysm: DDA makefiles explicitly require "g++", GCC's C++ compiler.
DEPEND="${RDEPEND}
	sys-devel/gcc[cxx]
"

# Github uses the repo name which is capitalized
S="${WORKDIR}/Cataclysm-DDA-${PV}"

src_unpack() {
	unpack ${A}
}
# Cataclysm: DDA makefiles are surprisingly Gentoo-friendly, requiring only
# light stripping of flags.
src_prepare() {
	sed -e "/OTHERS += -O3/d" -i 'Makefile' || die
}

# Compile a release rather than debug build.
# Disable -Werror it causes problems
src_compile() {
	if use tiles; then
		emake TILES=1 RELEASE=1 WARNINGS=""
	else
		emake RELEASE=1 WARNINGS=""
	fi
}

# Cataclysm: DDA makefiles define no "install" target. ("A pox on yer scurvy
# grave!")
src_install() {
	# Directory to install Cataclysm: DDA to.
	local cataclysm_home="${GAMES_DATADIR}/${PN}"
	local gamebin="cataclysm"

	# work with the tiles version since the makefile names them differently
	if use tiles; then
		gamebin="cataclysm-tiles"
	fi

	# The "cataclysm" executable expects to be executed from its home directory.
	# Make a wrapper script guaranteeing this.
	games_make_wrapper "${PN}" "./${gamebin}" "${cataclysm_home}"

	# Install Cataclysm: DDA.
	insinto "${cataclysm_home}"
	doins -r data
	exeinto "${cataclysm_home}"
	doexe "${gamebin}"

	# Force game-specific user and group permissions.
	prepgamesdirs

	# Since playing Cataclysm: DDA requires write access to its home directory,
	# forcefully grant such access to users in group "games". This is (clearly)
	# non-ideal, but there's not much we can do about that... at the moment.
	fperms -R g+w "${cataclysm_home}"
}
