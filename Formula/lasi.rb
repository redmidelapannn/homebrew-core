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
    sha256 "dbbb1ee6f50ac00978675679c1abc4061dd437a80e85036a9a25f7b2163b4c8e" => :mojave
    sha256 "955e4fbbd8ffa1626f35d926d087c1a1bf4fff4b1448bd9920dffbe56fc474f3" => :high_sierra
    sha256 "f67e035f9a4da341444413f79325a7ced0547b6038a22dbedac6e743ce729fa4" => :sierra
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
