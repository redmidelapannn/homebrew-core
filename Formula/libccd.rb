class Libccd < Formula
  desc "Library for collision detection between two convex shapes"
  homepage "http://libccd.danfis.cz"
  url "https://github.com/danfis/libccd/archive/v2.0.tar.gz"
  sha256 "1b4997e361c79262cf1fe5e1a3bf0789c9447d60b8ae2c1f945693ad574f9471"
  revision 2
  head "https://github.com/danfis/libccd.git"

  bottle do
    cellar :any
    sha256 "c6d186cc4f7f6fdd51f4dbfbd1c5adac866ce126b797bc1af753ba55acbb8353" => :high_sierra
    sha256 "aefc296be25b45850bb3635ff04af6ee3fcc7a878624b401c980ec5d957c07e5" => :sierra
    sha256 "89424d2102a0085da927b351f62d211cbcc3a2a74d413b8551db3826acb48dd1" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ccd/vec3.h>
      int main() {
        ccdVec3PointSegmentDist2(
          ccd_vec3_origin, ccd_vec3_origin,
          ccd_vec3_origin, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lccd"
    system "./test"
  end
end
