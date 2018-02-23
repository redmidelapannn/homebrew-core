class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz"
  sha256 "3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9c3420db765b591682398b2db9796f39791203d3b53cff1c361d37a6825eed70" => :high_sierra
    sha256 "4d807d374cb37098c66bfe92e83be1715c77de18761b077d49a9ff140e38dac0" => :sierra
    sha256 "6c3a57b162fa0f7941d507637494edfa3f37b1db996a339a4c899925505bec79" => :el_capitan
  end

  option "without-doxygen", "Do not build HTML documentation."
  option "with-static", "Build a static library."

  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :recommended]
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "libpng"

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"
    args << "-DBUILD_DOC=ON" if build.with? "doxygen"
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
