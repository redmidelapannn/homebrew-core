class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz"
  sha256 "3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "35a018398e7a4fc02d31455d9ed9b86fa6b1f8bd2e0a2190e75488c6fa051dbd" => :mojave
    sha256 "c251b082c4f3b5e11673f639c22f4c18cd2ba2cfbc7466deaf4776ea40ca4282" => :high_sierra
    sha256 "4d74518b63d48fedb5f6d21f3d4df9d2f4026021ab81a813e2da49e928b02e80" => :sierra
    sha256 "ce989a87333f95c702970a81dcb293f0bd182754f5c09f030ee2f4d7913d4f45" => :el_capitan
  end

  option "with-static", "Build a static library."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"
    args << "-DBUILD_DOC=ON"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lopenjp2",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
