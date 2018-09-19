class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.5.2.tar.bz2"
  sha256 "f0393d6df25ee92e0cbc6539c68ccf122caae0ffd5ae9a786163403bb2306cc5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5b85640b52a970b4eaff61b77e24059b47a8c7452fa848f5a368fe0074f42167" => :mojave
    sha256 "617f8d08bf654cc700f78091ee8b8dd24ff3218970eced511211f2afe2f25684" => :high_sierra
    sha256 "19874b420ef82059484dc855fc24dd32fd70474c2baac6e8c20a36211d5ffbcf" => :sierra
    sha256 "0138a03908784dd56e356dde0dfdf8e985dba73d8063d41289d3987ecdb32d53" => :el_capitan
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
