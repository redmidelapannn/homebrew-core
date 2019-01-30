class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"
  revision 1
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "742b9f95a39369dd1d7dd761ad3fcb3c6d154d6fd335d425649ccecefcc147d3" => :mojave
    sha256 "8b897de1d1ffe3895ff941952677246e6d1dcdd7c2854b5eca6d58425543600c" => :high_sierra
    sha256 "af527b092035e99e459cb35f1140f6467848c88adc3df183acc9312ba4040390" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"
  end
end
