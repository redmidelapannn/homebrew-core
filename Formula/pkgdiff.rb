class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.7.2.tar.gz"
  sha256 "d0ef5c8ef04f019f00c3278d988350201becfbe40d04b734defd5789eaa0d321"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02ad2b5cf4e9f4c519a125ed249f5314c3e975d00f72bacd2a35123fa2906cd6" => :mojave
    sha256 "33e8998b14443c7617c7fec22e90102eab368fb4f3561f8af45c1991981b643d" => :high_sierra
    sha256 "33e8998b14443c7617c7fec22e90102eab368fb4f3561f8af45c1991981b643d" => :sierra
    sha256 "33e8998b14443c7617c7fec22e90102eab368fb4f3561f8af45c1991981b643d" => :el_capitan
  end

  depends_on "binutils"
  depends_on "gawk"
  depends_on "wdiff"

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system bin/"pkgdiff"
  end
end
