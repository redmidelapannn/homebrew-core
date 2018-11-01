class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_2/ACE.tar.bz2"
  version "6.5.2"
  sha256 "f0393d6df25ee92e0cbc6539c68ccf122caae0ffd5ae9a786163403bb2306cc5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8f4f35f3b24d67c52844634ae8ce16b7be1f7931055cb242d5aba0f6a12fe2ee" => :mojave
    sha256 "b420b7901b7205f692fd07c5a31471395602ae842216d741e1e5d5f12d6696d7" => :high_sierra
    sha256 "7c6c1ef732338b6ce607fc4af3748b5b5605304618b9ba808ceb89cd59206023" => :sierra
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
