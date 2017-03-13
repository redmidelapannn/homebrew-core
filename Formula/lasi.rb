class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"

  head "https://svn.code.sf.net/p/lasi/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e84ed0543c1afe2f3ef9ab108a5c399d8108a22674ee332cd77b8e07b316af07" => :sierra
    sha256 "348e13a45c5a3e509a290714f8687395c72c04034912168f91de2c32388f7e6b" => :el_capitan
    sha256 "4499474efe890f61215c3ca199a6d5275be5c46ee3c76980eafb4ca3b71c98c5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"
  end
end
