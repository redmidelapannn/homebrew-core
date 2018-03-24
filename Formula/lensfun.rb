class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://dl.bintray.com/homebrew/mirror/lensfun-0.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  revision 3
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    rebuild 1
    sha256 "a3dd0ec581d11063558e1b2d749aeef70535da738e37afec6a8439ca03bde4b1" => :high_sierra
    sha256 "4af8ebee5bf010aac9b5f7f24a66f9f196573d972d4bccd5d13ee6d8188b8f51" => :sierra
    sha256 "59500111b88f92d3fba1d3f5816f74b57abeb47ea9ee1b36cfe0a222ec876598" => :el_capitan
  end

  depends_on "python"
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "doxygen" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
