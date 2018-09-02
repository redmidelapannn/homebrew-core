class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "http://www.libharu.org/"
  url "https://github.com/libharu/libharu/archive/RELEASE_2_3_0.tar.gz"
  sha256 "8f9e68cc5d5f7d53d1bc61a1ed876add1faf4f91070dbc360d8b259f46d9a4d2"
  head "https://github.com/libharu/libharu.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "54000fc6d71b7132e4352a43814f075fbb4da1c7aec832069388aa4fba974721" => :mojave
    sha256 "c38be2b86b7c68540b4e7fe80a43fd0ec4415fe6037a0479d392d8d38db05ce4" => :high_sierra
    sha256 "41a70337205175651ca15a77cfb793c67b9fa5f08e39941ef1a70e4ab83b3bc3" => :sierra
    sha256 "f452af553688cf0ea7d17ba62a71707635ea2642395a15cb69469a7bb94679fd" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpng"

  def install
    system "./buildconf.sh", "--force"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-png=#{Formula["libpng"].opt_prefix}
    ]

    args << "--with-zlib=#{MacOS.sdk_path}/usr" if MacOS.sdk_path_if_needed

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lhpdf", "-lz", "-o", "test"
    system "./test"
  end
end
