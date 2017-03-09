class Lensfun < Formula
  desc "Remove defects from digital images"
  homepage "https://lensfun.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lensfun/0.3.2/lensfun-0.3.2.tar.gz"
  sha256 "ae8bcad46614ca47f5bda65b00af4a257a9564a61725df9c74cb260da544d331"
  revision 1
  head "https://git.code.sf.net/p/lensfun/code.git"

  bottle do
    rebuild 1
    sha256 "c0333e95256a0c60b97be277a65b53bc801c65b1944351a339e00f5c3f4c63e6" => :sierra
    sha256 "3b57fe0cbb9174e98f040a3a48076671fc5205f7bddc1282385d02cdb656e9e3" => :el_capitan
    sha256 "98390b9da7c3ece91262759aef5c3bdf585ce7649a7c9470c84dca691adf7930" => :yosemite
  end

  depends_on :python3
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
