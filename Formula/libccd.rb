class Libccd < Formula
  homepage "http://libccd.danfis.cz"
  url "https://github.com/danfis/libccd/archive/v2.0.tar.gz"
  sha256 "1b4997e361c79262cf1fe5e1a3bf0789c9447d60b8ae2c1f945693ad574f9471"
  head "https://github.com/danfis/libccd.git"
  revision 1

  bottle do
    cellar :any
    sha256 "d25b30736b9a43c23d2ea3b6c599a6ccf36be0a0b5e9363dc3dd95731b8a1462" => :sierra
    sha256 "199871c244c8bd5e5a763d89155ea4f91cba08e3bacf6c6c319da9ec830bc620" => :el_capitan
    sha256 "ffc405eba32c839d8edc6349556315ddb4a35b8af21b5a4e48e7f2361f3ced63" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
