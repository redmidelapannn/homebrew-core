class Box2d < Formula
  desc "2D physics engine for games"
  homepage "http://www.box2d.org/"
  url "https://github.com/erincatto/Box2D/archive/v2.3.1.tar.gz"
  sha256 "75d62738b13d2836cd56647581b6e574d4005a6e077ddefa5d727d445d649752"
  head "https://github.com/erincatto/Box2D.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "492e3bec02a001a4680847b118e1011b3555ce053b90df3bc1b5b920143b691a" => :el_capitan
    sha256 "ccf95724cabcd92b522043c6ca2192fbe29f8ede5d8a4482a1466014d0695c2f" => :yosemite
    sha256 "ab29f36782e6f28548a58b1a4cf168e0f834f82cd9a4f60b1e51f8c156197368" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    cd "Box2D" do
      system "cmake", "-DBOX2D_INSTALL=ON",
                      "-DBOX2D_BUILD_SHARED=ON",
                      "-DBOX2D_BUILD_EXAMPLES=OFF",
                      *std_cmake_args
      system "make", "install"
    end
    libexec.install "Box2D/HelloWorld"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-lbox2d",
           libexec/"HelloWorld/HelloWorld.cpp", "-o", testpath/"test"
    system "./test"
  end
end
