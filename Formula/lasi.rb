class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"

  head "https://lasi.svn.sourceforge.net/svnroot/lasi/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2f0f8c10d302fd58722bde01feee7d93c7d9ae42a7401b955d081484e7b315c9" => :sierra
    sha256 "85504ce4a4543c3b2c42dc50db499bec3b4562e4b24b252db72caad7a0b73e3f" => :el_capitan
    sha256 "1bb6305b1a307665de30924308406c3c1f11e95c84135d28625c6a477b370deb" => :yosemite
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
