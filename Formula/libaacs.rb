class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.10.0/libaacs-0.10.0.tar.bz2"
  sha256 "93f6b19ef71e6f73e77bd7535946c09c45330e9b42e832a63a1d6b042f6b12fe"

  bottle do
    cellar :any
    sha256 "15f450f3791c82fde03dbdd59acc5c614d30cb777d58db630685b2cd80ca6a6c" => :catalina
    sha256 "f5d4738da0b0bf99411eb52798bea196e9188f5d56a39d041af23b0900f95d42" => :mojave
    sha256 "0e973891b93e76bd49346dde73cb7d18b0d31ad0962508c674d33bd87c546295" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libaacs/aacs.h"
      #include <stdio.h>

      int main() {
        int major_v = 0, minor_v = 0, micro_v = 0;

        aacs_get_version(&major_v, &minor_v, &micro_v);

        printf("%d.%d.%d", major_v, minor_v, micro_v);
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laacs",
                   "-o", "test"
    system "./test"
  end
end
