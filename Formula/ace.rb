class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.2.tar.bz2"
  sha256 "e334aa2f90e570c311d2c7cc18ca9908d682d86a537e358caadc01df1fdd4c37"

  bottle do
    cellar :any
    sha256 "3302a6f272a0968edcdec6caaedd0afc91db8093e1c91f8e964de7c070f9904d" => :sierra
    sha256 "ef41ee9c1a255fe9307cd62c4b3ae831bad0de1cde3f8a8ce031580df8b21acb" => :el_capitan
    sha256 "2465a229b6961babe512f71d97a588cb7c4f5151b5edf67bd30e99956353695b" => :yosemite
  end

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
