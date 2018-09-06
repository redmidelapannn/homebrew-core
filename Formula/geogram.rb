class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/37635/geogram_1.6.7.tar.gz"
  sha256 "08211b1d6f21e14701e3fd5c79adbe331cdf66b8af84efdb54cd7048244691b5"

  bottle do
    sha256 "9ad68766c5c05e95764af70b363dd50fda648fa2184a980fab50ae7b985471e6" => :mojave
    sha256 "5c518537a4a864bbe89ab72f9f43f4d328afd6f05f51be5e35c2cd41fe7c7ee6" => :high_sierra
    sha256 "96ed9a0ce52c8db44c9f785e297d6177db9be512364b7050d217a0df2dd70f55" => :sierra
    sha256 "d01da43cd0bb01301e77a0084d9d315ec138c30ba00030cb5c70ff1c09fcbeec" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  resource "bunny" do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  def install
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    EOS

    system "./configure.sh"
    cd "build/Darwin-clang-dynamic-Release" do
      system "make", "install"
    end

    (share/"cmake/Modules").install Dir[lib/"cmake/modules/*"]
  end

  test do
    resource("bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
