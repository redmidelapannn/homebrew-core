class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.12/wesnoth-1.12.6/wesnoth-1.12.6.tar.bz2"
  sha256 "a50f384cead15f68f31cfa1a311e76a12098428702cb674d3521eb169eb92e4e"
  revision 8
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "8ff628f68c0d53d741842b3e9420c239d7af1e0bfe2797785c6a7afcdb71239f" => :mojave
    sha256 "851874f5cf9843fae20448c29565357d6ad791e52ff4eba287856ac4998f1d99" => :high_sierra
    sha256 "8508cfb53a817c32ec3a0da05fc9c8e0fb8e02f9164a50ecfa98d13959396558" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "libpng"
  depends_on "pango"
  depends_on "sdl"
  depends_on "sdl_image" # Must have png support
  depends_on "sdl_mixer" # The music is in .ogg format
  depends_on "sdl_net"
  depends_on "sdl_ttf"

  def install
    mv "scons/gettext.py", "scons/gettext_tool.py"
    inreplace "SConstruct", ", \"gettext\",", ", \"gettext_tool\","

    args = %W[prefix=#{prefix} docdir=#{doc} mandir=#{man} fifodir=#{var}/run/wesnothd gettextdir=#{Formula["gettext"].opt_prefix}]
    args << "OS_ENV=true"
    args << "install"
    args << "wesnoth"
    args << "wesnothd"
    args << "-j#{ENV.make_jobs}"

    scons *args
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
