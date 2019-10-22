class Srecord < Formula
  desc "Tools for manipulating EPROM load files"
  homepage "https://srecord.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srecord/srecord/1.64/srecord-1.64.tar.gz"
  sha256 "49a4418733c508c03ad79a29e95acec9a2fbc4c7306131d2a8f5ef32012e67e2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a59f54c53aacff53d35f1f34c2e58de279557a9f30100f74841fe3cd7b25049b" => :catalina
    sha256 "afa8be1d741be6b60599540cfd70cc23bb2f5c0d126a41ccb1ef1d389fa0e103" => :mojave
    sha256 "8d731a8cb7f4c03cdb7f6ff44467314147f497c67fce7a9ad684faee8ae287cb" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "libgcrypt"

  # Use macOS's pstopdf
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/srecord/1.64.patch"
    sha256 "140e032d0ffe921c94b19145e5904538233423ab7dc03a9c3c90bf434de4dd03"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install"
  end
end
