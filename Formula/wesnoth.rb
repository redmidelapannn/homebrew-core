class Wesnoth < Formula
  desc "Single- and multi-player turn-based strategy game"
  homepage "https://www.wesnoth.org/"
  url "https://downloads.sourceforge.net/project/wesnoth/wesnoth-1.14/wesnoth-1.14.5/wesnoth-1.14.5.tar.bz2"
  sha256 "05317594b1072b6cf9f955e3a7951a28096f8b1e3afed07825dd5a219c90f7cd"
  head "https://github.com/wesnoth/wesnoth.git"

  bottle do
    sha256 "b853c878afc581602ef2bd6237021c7ab4f3df19f39f092a92cbfe5ea465826b" => :mojave
    sha256 "788865149c99eab9da79c5587d4471facf8f6e3de0e7290413ebfe1297fd7cb0" => :high_sierra
    sha256 "9d67663035bd6ddee29dfccf13555c53bfcd274a932edd14028fdcbbf2ba77c2" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "openssl"
  depends_on "pango"
  depends_on "sdl2"
  depends_on "sdl2_image" # Must have png support
  depends_on "sdl2_mixer" # The music is in .ogg format
  depends_on "sdl2_ttf"

  def install
    scons "prefix=#{prefix}", "docdir=#{doc}", "mandir=#{man}",
      "fifodir=#{var}/run/wesnothd",
      "gettextdir=#{Formula["gettext"].opt_prefix}",
      "extra_flags_config=-I#{Formula["openssl"].opt_include} -L#{Formula["openssl"].opt_lib}",
      "OS_ENV=true", "install", "wesnoth", "wesnothd", "-j#{ENV.make_jobs}"
  end

  test do
    system bin/"wesnoth", "-p", pkgshare/"data/campaigns/tutorial/", testpath
  end
end
