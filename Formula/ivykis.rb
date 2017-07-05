class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis"
  url "https://downloads.sourceforge.net/project/libivykis/0.41/ivykis-0.41.tar.gz"
  sha256 "2c934539a59029851b1332c8143ba9f21b79fb0185dd68d6eb259ae1b61ef3c5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "be42db7e65ea4574c3c13f451b69ba98ff6a7778557be3d4d880bdcffcf7f2e3" => :sierra
    sha256 "bb8da8a94b2cff0b1f08d03d2fbd0ef4233973a7adb3cb78adc336e0c39f007f" => :el_capitan
    sha256 "1e95f033046cc2f6deb36d8cc62e545a6b4276e0c9042508a8d0ed09cec07976" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<-EOS.undent
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
