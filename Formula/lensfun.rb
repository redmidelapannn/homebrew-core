class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.95/lensfun-0.3.95.tar.gz"
  sha256 "82c29c833c1604c48ca3ab8a35e86b7189b8effac1b1476095c0529afb702808"
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    rebuild 1
    sha256 "74b47d2aa9e115c0d9634a93efadfcfb5aac0e10e5b0eff5b9afe8d23ca615f1" => :mojave
    sha256 "a09214ad50c21487e25bfdfda750c1c5f43f81d227541ab4dad170584e197b3a" => :high_sierra
    sha256 "3acd73c6f497b0f9af76b079a9825a360b7fc6b758c61d196e3a7489206eabe4" => :sierra
    sha256 "ee2cc93988966584506f9ba9e51e7b35bbbde3ffc6b42068e1587a758b03c20e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
