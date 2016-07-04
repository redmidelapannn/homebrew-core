class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.0.tar.bz2"
  sha256 "6a7fd5f23f6a004bb21978767df4e36adea078cd344e45bab50266213586c001"

  bottle do
    cellar :any
    revision 1
    sha256 "2b24e985bdc7ec10a0f416f5851e1a8d7fa19889f5f6ef98c6d2c34650f6fe95" => :el_capitan
    sha256 "d9007b71398fa280ca4afadce0322362a20ca95cd2578b0b820acf1a8b345db5" => :yosemite
    sha256 "baca97207b2c174cdb3f201b54df0b26b9c1373d98a107c967d821e068d82c1e" => :mavericks
  end

  def install
    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

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
